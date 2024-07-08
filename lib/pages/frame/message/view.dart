import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.Contact);
        },
        backgroundColor: AppColors.primaryElement,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("assets/icons/contact.png"),
        ),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: _headBar(),
              )
            ],
          )
        ],
      )),
    );
  }

  Widget _headBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35.h),
      child: Row(
        children: [
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  controller.goProfile();
                },
                child: Container(
                  width: 44.h,
                  height: 44.h,
                  decoration: BoxDecoration(
                      color: AppColors.primarySecondaryBackground,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 1))
                      ]),
                  child: controller.state.headDetails.value.avatar == null
                      ? Image.asset("assets/images/account_header.png")
                      : const Text("Hi"),
                ),
              ),
              Positioned(
                bottom: 5.w,
                right: 0.w,
                height: 14.w,
                child: Container(
                  width: 10,
                  height: 01,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryElementStatus),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
