import 'package:chatty/pages/frame/welcome/controller.dart';
import 'package:get/get.dart';
import 'controller.dart';

class SignInBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<SignInController>(() => SignInController());
  }
}