import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: Obx(() => SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildProfilePhoto(),
                          _buildCompleteBtn(),
                          _buildLogOutBtn(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "Profile",
        style: TextStyle(
            color: AppColors.primaryText,
            fontSize: 16.sp,
            fontWeight: FontWeight.normal),
      ),
    );
  }

  Widget _buildProfilePhoto() {
    return Stack(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
              color: AppColors.primarySecondaryBackground,
              borderRadius: BorderRadius.circular(60.w),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                    spreadRadius: 1)
              ]),
          child: controller.state.profileDetail.value.avatar != null
              ? CachedNetworkImage(
                  imageUrl: controller.state.profileDetail.value.avatar!,
                  fit: BoxFit.fill,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: imageProvider)),
                  ),
                )
              : Image.asset(
                  "assets/images/account_header.png",
                  fit: BoxFit.cover,
                ),
        ),
        Positioned(
          right: 0,
          bottom: 10,
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.all(7),
              width: 35.w,
              height: 35.h,
              decoration: BoxDecoration(
                color: AppColors.primaryElement,
                borderRadius: BorderRadius.circular(40.w),
              ),
              child: Image.asset(
                "assets/icons/edit.png",
                width: 25,
                height: 25,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildCompleteBtn() {
    return ElevatedButton(
      onPressed: () {},
      style: ButtonStyle(
          backgroundColor:
              const MaterialStatePropertyAll<Color>(AppColors.primaryElement),
          shape: MaterialStatePropertyAll<OutlinedBorder>(
              ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(16)))),
      child: Center(
        child: Text(
          "Complete",
          style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 14.sp,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget _buildLogOutBtn() {
    return ElevatedButton(
      onPressed: () {
        Get.defaultDialog(
            title: "Are you sure to log out?",
            textConfirm: "Confirm",
            content: const SizedBox(),
            textCancel: "Cancel",
            titleStyle: const TextStyle(fontSize: 16),
            onCancel: () {},
            onConfirm: () {
              controller.goLogout();
            });
      },
      style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll<Color>(
              AppColors.primarySecondaryElementText),
          shape: MaterialStatePropertyAll<OutlinedBorder>(
              ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(16)))),
      child: Center(
        child: Text(
          "Logout",
          style: TextStyle(
              color: AppColors.primaryElementText,
              fontSize: 14.sp,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
