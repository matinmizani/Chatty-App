import 'dart:convert';
import 'dart:math';

import 'package:chatty/common/apis/apis.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/routes.dart';
import 'package:chatty/common/store/store.dart';
import 'package:chatty/common/utils/http.dart';
import 'package:chatty/common/widgets/toast.dart';
import 'package:chatty/pages/frame/sign_in/state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInController extends GetxController {
  SignInController();

  final state = SignInState();

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ["openid"]);

  void handleSignIn(String type) async {
    try {
      if (type == "phone number") {
        print("you are logging in with phone number ...");
      } else if (type == "google") {
        var user = await _googleSignIn.signIn();
        if (user != null) {
          final _gAuthentication = await user.authentication;
          final _credential = GoogleAuthProvider.credential(
              idToken: _gAuthentication.idToken,
              accessToken: _gAuthentication.accessToken);
          String? displayName = user.displayName;
          String email = user.email;
          String id = user.id;
          String photoUrl = user.photoUrl ?? 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png';
          LoginRequestEntity loginPanelListRequestEntity = LoginRequestEntity();
          loginPanelListRequestEntity.avatar = photoUrl;
          loginPanelListRequestEntity.name = displayName;
          loginPanelListRequestEntity.email = email;
          loginPanelListRequestEntity.open_id = id;
          loginPanelListRequestEntity.type = 2;
          asyncPostAllData(loginPanelListRequestEntity);
        }
      } else {
        if (kDebugMode) {
          print("login type not sure...");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("error with login $e");
      }
    }
  }

  asyncPostAllData(LoginRequestEntity loginRequestEntity) async {
    EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.clear);
    var result = await UserAPI.Login(params: loginRequestEntity);
    if (result.code == 0) {
      await UserStore.to.saveProfile(result.data!);
      EasyLoading.dismiss();
      Get.offAllNamed(AppRoutes.Message);
    }else{
      EasyLoading.dismiss();
      toastInfo(msg: "Internet error");
      Get.offAllNamed(AppRoutes.Message);
    }
  }
}
