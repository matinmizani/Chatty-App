import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/welcome/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class WelcomePage extends GetView<WelcomeController> {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryElement,
      body: Container(
        margin: const EdgeInsets.only(top: 350),
        child: _buildPageHeadTitle(controller.title),
      ),
    );
  }

  Widget _buildPageHeadTitle(String title) {
    return SizedBox(
      width: 360.w,
      height: 780.h,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: AppColors.primaryElementText,
            fontFamily: "Mont",
            fontWeight: FontWeight.bold,
            fontSize: 45.sp),
      ),
    );
  }
}
