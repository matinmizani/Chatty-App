import 'package:chatty/pages/frame/message/index.dart';
import 'package:chatty/pages/frame/profile/controller.dart';
import 'package:get/get.dart';

class ProfileBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ProfileController>(() => ProfileController());
  }
}