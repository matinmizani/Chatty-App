import 'package:chatty/common/store/store.dart';
import 'package:chatty/pages/frame/profile/index.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfileController extends GetxController{
  ProfileController();
  final state = ProfileState();

  void goLogout()async{
    await UserStore.to.onLogout();
    await GoogleSignIn().signOut();
  }
  @override
  void onInit(){
    super.onInit();
    var userItem = Get.arguments;
    if(userItem!=null){
      state.profileDetail.value = userItem;
    }
  }
}