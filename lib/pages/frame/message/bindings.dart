import 'package:chatty/pages/frame/message/index.dart';
import 'package:get/get.dart';

class MessageBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<MessageController>(() => MessageController());
  }
}