import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/pages/frame/message/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  MessageController();

  final state = MessageState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.profile.token;

  void goProfile() async {
    await Get.toNamed(AppRoutes.Profile, arguments: state.headDetails.value);
  }

  goTabStatus() {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear,
        dismissOnTap: true);
    state.tabStatus.value = !state.tabStatus.value;
    if (state.tabStatus.value) {
      asyncLoadMsgData();
    } else {}
    EasyLoading.dismiss();
  }

  Future<void> asyncLoadMsgData() async {

    var from_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, option) => msg.toFirestore())
        .where("from_token", isEqualTo: token)
        .get();
    print(from_message.docs.length);
    var to_message = await db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, option) => msg.toFirestore())
        .where("to_token", isEqualTo: token)
        .get();
    print(to_message.docs.length);

    state.msgList.clear();

    if (from_message.docs.isNotEmpty) {
      await addMessage(from_message.docs);
    }

    if (to_message.docs.isNotEmpty) {
      await addMessage(to_message.docs);
    }
  }

   addMessage(List<QueryDocumentSnapshot<Msg>> data){
    data.forEach((element) {
      var item = element.data();
      Message message = Message();
      //saves the common properties
      message.doc_id = element.id;
      message.last_time = item.last_time;
      message.msg_num = item.msg_num;
      message.last_msg = item.last_msg;
      if(item.from_token==token){
        message.name = item.to_name;
        message.avatar = item.to_avatar;
        message.token = item.to_token;
        message.online = item.to_online;
        message.msg_num = item.to_msg_num??0;
      }else{
        message.name = item.from_name;
        message.avatar = item.from_avatar;
        message.token = item.from_token;
        message.online = item.from_online;
        message.msg_num = item.from_msg_num??0;
      }
      state.msgList.add(message);
    });

  }

  @override
  void onReady() {
    super.onReady();
    firebaseMessageSetup();
  }

  @override
  void onInit() {
    super.onInit();
    getProfile();
    _snapShots();
  }

  _snapShots() {
    final toMessageRef = db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, option) => msg.toFirestore())
        .where("to_token", isEqualTo: token);
    final fromMessageRef = db
        .collection("message")
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, option) => msg.toFirestore())
        .where("from_token", isEqualTo: token);
    toMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });
    fromMessageRef.snapshots().listen((event) {
      asyncLoadMsgData();
    });
  }

  void getProfile() async {
    var profile = await UserStore.to.profile;
    state.headDetails.value = profile;
    state.headDetails.refresh();
    print(state.headDetails.value.avatar);
  }

  firebaseMessageSetup() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print(".....my device token is $fcmToken");
    if (fcmToken != null) {
      BindFcmTokenRequestEntity bindFcmTokenRequestEntity =
          BindFcmTokenRequestEntity();
      bindFcmTokenRequestEntity.fcmtoken = fcmToken;
      // await ChatAPI.bind_fcmtoken(params: bindFcmTokenRequestEntity);
    }
  }
}
