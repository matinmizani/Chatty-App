import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:chatty/pages/frame/message/chat/index.dart';
import 'package:chatty/pages/frame/message/chat/state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  ChatController();

  final state = ChatState();
  late String doc_id;
  final myInputController = TextEditingController();

  //firebase data instance
  final db = FirebaseFirestore.instance;

  //Sender token
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

    var list = await db.collection("people").add({
      "name": myInputController.text,
      "age": 35,
      "addtime": Timestamp.now(),
    });

    var myList = await db
        .collection("people")
        .orderBy("addtime", descending: true)
        .limit(3).snapshots();

    myList.listen((event) {
      for(var change in event.docChanges){
        switch(change.type) {
          case DocumentChangeType.added:
            print("...added a document oject ${change.doc.id}");
            break;
          case DocumentChangeType.modified:
            print("... changed value ${change.doc["age"]}");
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }
      }
    });
    

    
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
      print("...base id is :$doc_id new message doc id is ${doc.id}");
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
}
