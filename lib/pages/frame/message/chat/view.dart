import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/message/chat/widgets/chat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: _appBar(),
      body: Obx(() => Padding(
          padding: const EdgeInsets.all(16.0),
          child: SafeArea(
              child: Stack(
            children: [
              const ChatList(),
              Positioned(
                  bottom: 0,
                  child: Row(
                    children: [
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width - 80,
                        constraints: BoxConstraints(
                            minHeight: 50,
                            maxHeight: 200,
                            minWidth: MediaQuery.of(context).size.width - 80),
                        child: TextField(
                          minLines: 1,
                          maxLines: 20,
                          controller: controller.myInputController,
                          textAlign: TextAlign.start,
                          keyboardType: TextInputType.multiline,
                          autofocus: false,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Image.asset("assets/icons/send.png"),
                                  )),
                              onTap: () {
                                controller.sendMessage();
                              },
                            ),
                            hintText: "Message....",
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.goMore();
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  )),
              controller.state.moreStatus.value
                  ? Positioned(
                      right: 0,
                      bottom: 70.h,
                      child: Column(
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: Image.asset("assets/icons/file.png"),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: Image.asset("assets/icons/photo.png"),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.audioCall();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: Image.asset("assets/icons/call.png"),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 2,
                                        offset: const Offset(0, 1))
                                  ]),
                              child: Image.asset("assets/icons/video.png"),
                            ),
                          ),
                        ],
                      ))
                  : Container()
            ],
          )))),
    );
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      title: Obx(() {
        return Text(
          "${controller.state.to_name}",
          overflow: TextOverflow.clip,
          maxLines: 1,
          style: TextStyle(fontSize: 16.sp),
        );
      }),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                    width: 40.h,
                    height: 40.h,
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
                    child: CachedNetworkImage(
                      imageUrl: controller.state.to_avatar.value,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: imageProvider),
                        ),
                      ),
                    )),
              ),
              Positioned(
                bottom: 5.w,
                right: 0.w,
                height: 14.w,
                child: Container(
                  width: 10,
                  height: 01,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: controller.state.to_online.value == "1"
                          ? AppColors.primaryElementStatus
                          : AppColors.primarySecondaryElementText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
