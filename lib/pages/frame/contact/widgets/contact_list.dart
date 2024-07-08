import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/entities/contact.dart';
import 'package:chatty/common/style/color.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/pages/frame/contact/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContactList extends GetView<ContactController> {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 0.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                var item = controller.state.contactList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildListItem(item),
                );
              }, childCount: controller.state.contactList.length),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildListItem(ContactItem item) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: 1, color: AppColors.primarySecondaryBackground)),
      ),
      child: InkWell(
        onTap: () {
          controller.goChat(item);
        },
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: const BoxDecoration(
                  color: AppColors.primarySecondaryBackground,
                  shape: BoxShape.circle),
              child: CachedNetworkImage(
                imageUrl: item.avatar!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider),
                      shape: BoxShape.circle),
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Text("${item.name}"),
            const Expanded(child: SizedBox()),
            SizedBox(
                width: 12.w,
                height: 12.w,
                child: Image.asset("assets/icons/ang.png")),
          ],
        ),
      ),
    );
  }
}
