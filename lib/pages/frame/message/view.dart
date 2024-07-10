import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/routes/names.dart';
import 'package:chatty/common/utils/date.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: Obx(() => SafeArea(
              child: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    title: _headBar(),
                  ),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                    sliver: SliverToBoxAdapter(
                      child: _headTabs(),
                    ),
                  ),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.w, horizontal: 20.w),
                    sliver: controller.state.tabStatus.value
                        ? SliverList(
                            delegate:
                                SliverChildBuilderDelegate((context, index) {
                            var item = controller.state.msgList[index];
                            return _chatListItem(item);
                          }, childCount: controller.state.msgList.length))
                        : SliverToBoxAdapter(
                            child: Container(),
                          ),
                  )
                ],
              )
            ],
          ))),
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
                      : CachedNetworkImage(
                          imageUrl: controller.state.headDetails.value.avatar!,
                          height: 44.w,
                          width: 44.w,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill)),
                          ),
                        ),
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

  Widget _headTabs() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(4.w),
        height: 55.h,
        width: 320.w,
        decoration: BoxDecoration(
          color: AppColors.primarySecondaryBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                controller.goTabStatus();
              },
              child: Container(
                width: 150.w,
                height: 40.h,
                decoration: controller.state.tabStatus.value
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primaryBackground,
                        boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(0, 2))
                          ])
                    : const BoxDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "chat",
                      style: TextStyle(
                          color: AppColors.primaryThreeElementText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.goTabStatus();
              },
              child: Container(
                decoration: !controller.state.tabStatus.value
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primaryBackground,
                        boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(0, 2))
                          ])
                    : const BoxDecoration(),
                width: 150.w,
                height: 40.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "call",
                      style: TextStyle(
                          color: AppColors.primaryThreeElementText,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _chatListItem(Message item) {
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 0.w, right: 0.w, bottom: 10.h),
      child: InkWell(
        onTap: () {
          if (item.doc_id != null) {
            Get.toNamed("/chat", parameters: {
              "doc_id": item.doc_id!,
              "to_token": item.token!,
              "to_name": item.name!,
              "to_avatar": item.avatar!,
              "to_online": item.online.toString()
            });
          }
        },
        child: Row(
          children: [
            Container(
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
              child: item.avatar == null
                  ? Image.asset("assets/images/account_header.png")
                  : CachedNetworkImage(
                      imageUrl: item.avatar!,
                      height: 44.w,
                      width: 44.w,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill)),
                      ),
                    ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 175.w,
                    height: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${item.name}",
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.bold,
                              color: AppColors.thirdElement,
                              fontSize: 14.sp),
                        ),
                        Text("${item.last_msg}",
                            style: TextStyle(
                                fontFamily: "Avenir",
                                fontWeight: FontWeight.normal,
                                color: AppColors.primarySecondaryElementText,
                                fontSize: 12.sp))
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 85.w,
                    height: 44.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          item.last_time == null
                              ? ""
                              : duTimeLineFormat(
                                  (item.last_time as Timestamp).toDate()),
                          style: TextStyle(
                              fontFamily: "Avenir",
                              fontWeight: FontWeight.normal,
                              color: AppColors.primarySecondaryElementText,
                              fontSize: 12.sp),
                        ),
                        item.msg_num == 0
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                decoration: const BoxDecoration(
                                    color: Colors.red, shape: BoxShape.circle),
                                child: Text("${item.msg_num}",
                                    style: TextStyle(
                                        fontFamily: "Avenir",
                                        fontWeight: FontWeight.normal,
                                        color: AppColors
                                            .primarySecondaryElementText,
                                        fontSize: 12.sp)),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
