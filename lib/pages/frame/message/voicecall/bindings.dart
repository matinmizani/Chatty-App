import 'package:chatty/pages/frame/message/index.dart';
import 'package:chatty/pages/frame/message/voicecall/controller.dart';
import 'package:get/get.dart';

class VoiceCallBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<VoiceCallController>(() => VoiceCallController());
  }
}