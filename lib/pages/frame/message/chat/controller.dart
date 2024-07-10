import 'dart:async';
import 'dart:io';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:chatty/pages/frame/message/chat/index.dart';
import 'package:chatty/pages/frame/message/chat/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();
  late String doc_id;
  final myInputController = TextEditingController();
  final db = FirebaseFirestore.instance;
  var listener;
  var isLoadMore = true;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  ScrollController myScrollController = ScrollController();

  final token = UserStore.to.profile.token;

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    print(data);
    doc_id = data["doc_id"]!;
    state.to_token.value = data['to_token'] ?? "";
    state.to_name.value = data['to_name'] ?? "";
    state.to_avatar.value = data['to_avatar'] ?? "";
    state.to_online.value = data['to_online'] ?? "";
    clearMsgNum(doc_id);
  }

  Future<void> clearMsgNum(String docId) async {
    var messageResult = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .get();
    //to know if we have any unread messages or calls
    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        to_msg_num =0;
      } else {
        from_msg_num =0;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
    state.msgContentList.clear();
    final messages = db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, option) => msg.toFirestore())
        .orderBy("addtime", descending: true)
        .limit(15);
    listener = messages.snapshots().listen((event) {
      List<Msgcontent> temMsgList = <Msgcontent>[];
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              temMsgList.add(change.doc.data()!);
              print(change.doc.data()?.content);
            }
            break;
          case DocumentChangeType.modified:
            // TODO: Handle this case.
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
      //4,3,2,1 => 1,2,3,4
      temMsgList.reversed.forEach((element) {
        state.msgContentList.value.insert(0, element);
      });
      state.msgContentList.refresh();
      if (myScrollController.hasClients) {
        myScrollController.animateTo(
            myScrollController.position.minScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut);
      }
    });
    myScrollController.addListener(() {
      if (myScrollController.offset + 20 >
          myScrollController.position.maxScrollExtent) {
        if (isLoadMore) {
          state.isLoading.value = true;
          isLoadMore = false;
          asyncLoadMoreData();
        }
      }
    });
  }

  void goMore() {
    state.moreStatus.value = state.moreStatus.value ? false : true;
  }

  void audioCall() {
    state.moreStatus.value = false;
    Get.toNamed(AppRoutes.VoiceCall, parameters: {
      "to_name": state.to_name.value,
      "to_avatar": state.to_avatar.value,
      "call_role": "anchor",
      "to_token": state.to_token.value,
      "doc_id": doc_id
    });
  }

  Future<void> sendMessage() async {
    String sendContent = myInputController.text;
    if (sendContent.isEmpty) {
      toastInfo(msg: "content is empty");
      return;
    }
    //created an object to send to fire base
    final content = Msgcontent(
        token: token,
        content: sendContent,
        type: "text",
        addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
      myInputController.clear();
    });
    var messageResult = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .get();
    //to know if we have any unread messages or calls
    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
        "last_msg": sendContent,
        "last_time": Timestamp.now()
      });
    }
  }

  Future<void> asyncLoadMoreData() async {
    final message = await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
            fromFirestore: Msgcontent.fromFirestore,
            toFirestore: (Msgcontent msg, option) => msg.toFirestore())
        .orderBy("addtime", descending: true)
        .where("addtime", isLessThan: state.msgContentList.value.last.addtime)
        .limit(10)
        .get();
    if (message.docs.isNotEmpty) {
      message.docs.forEach((element) {
        var data = element.data();
        state.msgContentList.add(data);
      });
    }
    SchedulerBinding.instance.addPersistentFrameCallback((timeStamp) {
      isLoadMore = true;
    });
    state.isLoading.value = false;
  }

  Future<void> imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      uploadFile();
    } else {
      print("no image selected");
    }
  }

  Future<void> uploadFile() async {
    var result = await ChatAPI.upload_img(file: _photo);
    print(result.data);
    if(result.code==0){
      sendImageMessage(result.data!);
    }else{
      toastInfo(msg: "sending image error");
    }
  }

  Future<void> sendImageMessage(String url) async {

    //created an object to send to fire base
    final content = Msgcontent(
        token: token,
        content: url,
        type: "image",
        addtime: Timestamp.now());

    await db
        .collection("message")
        .doc(doc_id)
        .collection("msglist")
        .withConverter(
        fromFirestore: Msgcontent.fromFirestore,
        toFirestore: (Msgcontent msg, options) => msg.toFirestore())
        .add(content)
        .then((DocumentReference doc) {
    });
    var messageResult = await db
        .collection("message")
        .doc(doc_id)
        .withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .get();
    //to know if we have any unread messages or calls
    if (messageResult.data() != null) {
      var item = messageResult.data()!;
      int to_msg_num = item.to_msg_num == null ? 0 : item.to_msg_num!;
      int from_msg_num = item.from_msg_num == null ? 0 : item.from_msg_num!;
      if (item.from_token == token) {
        from_msg_num = from_msg_num + 1;
      } else {
        to_msg_num = to_msg_num + 1;
      }
      await db.collection("message").doc(doc_id).update({
        "to_msg_num": to_msg_num,
        "from_msg_num": from_msg_num,
        "last_msg": " [image] ",
        "last_time": Timestamp.now()
      });
    }
    state.moreStatus.value=false;
  }

  Future<void> closeAllPop()async{
    Get.focusScope?.unfocus();
    state.moreStatus.value = false;
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
    myScrollController.dispose();
    myInputController.dispose();
  }

  @override
  void onClose(){
    super.onClose();
    clearMsgNum(doc_id);
  }
}
