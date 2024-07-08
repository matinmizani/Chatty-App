import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/sign_in/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignInPage extends GetView<SignInController> {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primarySecondaryBackground,
        body: Center(
          child: Column(
            children: [
              _buildLogo(),
              _buildLoginType("Sign in with Google", "assets/icons/google.png"),
              _buildLoginType(
                  "Sign in with FaceBook", "assets/icons/facebook.png"),
              _buildLoginType("Sign in with Apple", "assets/icons/apple.png"),
              const SizedBox(
                height: 8,
              ),
              _customDivider(),
              _buildLoginType("Sign in with phone number", null),
              SizedBox(
                height: 30.h,
              ),
              _buildSignUpWidget(),
            ],
          ),
        ));
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.only(top: 100.h, bottom: 80.h),
      child: Text(
        "Chatty .",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 34.sp,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLoginType(String loginType, String? assets) {
    return GestureDetector(
      onTap: () {
        controller.handleSignIn("google");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: 295.w,
        height: 44.h,
        decoration: BoxDecoration(
            color: AppColors.primaryBackground,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 1),
              )
            ]),
        child: Row(
          mainAxisAlignment: assets == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            assets == null
                ? const SizedBox()
                : Container(
                    height: 25,
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Image.asset(assets),
                  ),
            Text(
              loginType,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.primaryText,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Widget _customDivider() {
    return Row(
      children: [
        Expanded(
            child: Divider(
          height: 2.h,
          color: AppColors.primarySecondaryElementText,
          indent: 35,
        )),
        const Text("  or  "),
        Expanded(
            child: Divider(
          height: 2.h,
          color: AppColors.primarySecondaryElementText,
          endIndent: 35,
        )),
      ],
    );
  }

  Widget _buildSignUpWidget() {
    return Column(
      children: [
        Text(
          "Already have an account",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: AppColors.primaryText,
              fontWeight: FontWeight.normal,
              fontSize: 12.sp),
        ),
        GestureDetector(
          child: Text(
            "Sign up here",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: AppColors.primaryElement,
                fontWeight: FontWeight.normal,
                fontSize: 12.sp),
          ),
        ),
      ],
    );
  }
}
