import 'package:chatty/pages/frame/message/chat/index.dart';
import 'package:get/get.dart';

class ChatBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ChatController>(() => ChatController());
  }
}