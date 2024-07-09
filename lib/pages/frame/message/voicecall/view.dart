import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class VoiceCallPage extends GetView<VoiceCallController> {
  const VoiceCallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primary_bg,
        body: Obx(() => SafeArea(
              child: Stack(
                children: [
                  Positioned(
                      top: 10.h,
                      left: 30.w,
                      right: 30.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            controller.state.callTime.value,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                          const SizedBox(
                            height: 150,
                          ),
                          SizedBox(
                              width: 70.w,
                              height: 70.h,
                              child: Image.network(
                                  controller.state.to_avatar.value)),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            controller.state.to_name.value,
                            style: TextStyle(
                                color: AppColors.primaryElementText,
                                fontSize: 18.sp),
                          ),
                        ],
                      )),
                  Positioned(
                      bottom: 80.h,
                      left: 30.w,
                      right: 30.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.state.openMicrophone.value
                                              ? AppColors.primaryElementText
                                              : AppColors.primaryText),
                                  child: controller.state.openMicrophone.value
                                      ? Image.asset(
                                          "assets/icons/b_microphone.png")
                                      : Image.asset(
                                          "assets/icons/a_microphone.png"),
                                ),
                              ),
                              Text(
                                "Microphone",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 12.sp),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: controller.state.isJoined.value
                                    ? controller.leaChannel
                                    : controller.joinChannel,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.state.isJoined.value
                                          ? AppColors.primaryElementBg
                                          : AppColors.primaryElementStatus),
                                  child: controller.state.isJoined.value
                                      ? Image.asset("assets/icons/a_phone.png")
                                      : Image.asset(
                                          "assets/icons/a_telephone.png"),
                                ),
                              ),
                              Text(
                                controller.state.isJoined.value
                                    ? "Disconnect"
                                    : "Connect",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 12.sp),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.state.enableSpeaker.value
                                              ? AppColors.primaryElementText
                                              : AppColors.primaryText),
                                  child: controller.state.enableSpeaker.value
                                      ? Image.asset(
                                          "assets/icons/b_trumpet.png")
                                      : Image.asset(
                                          "assets/icons/b_trumpet.png"),
                                ),
                              ),
                              Text(
                                "Speaker",
                                style: TextStyle(
                                    color: AppColors.primaryElementText,
                                    fontSize: 12.sp),
                              )
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            )));
  }
}
