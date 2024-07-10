import 'package:chatty/pages/frame/message/chat/controller.dart';
import 'package:chatty/pages/frame/message/chat/widgets/chat_left_list.dart';
import 'package:chatty/pages/frame/message/chat/widgets/chat_right_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          padding: EdgeInsets.only(bottom: 70.h),
          child: GestureDetector(
            onTap: () {
              controller.closeAllPop();
            },
            child: CustomScrollView(
              controller: controller.myScrollController,
              reverse: true,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(
                    vertical: 0.w,
                    horizontal: 0.w,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      var item = controller.state.msgContentList[index];
                      if (controller.token == item.token) {
                        return chatRightList(item);
                      }
                      return chatLeftList(item);
                    }, childCount: controller.state.msgContentList.length),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                  sliver: SliverToBoxAdapter(
                    child: controller.state.isLoading.value
                        ? const Align(
                            alignment: Alignment.center,
                            child: Text("loading..."),
                          )
                        : Container(),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
