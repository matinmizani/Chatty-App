import 'package:chatty/pages/frame/message/index.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ContactBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ContactController>(() => ContactController());
  }
}