import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatty/common/entities/entities.dart';
import 'package:chatty/common/values/colors.dart';
import 'package:chatty/common/values/server.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget chatRightList(Msgcontent item) {
  String? imagePath;
  if(item.type=="image"){
    imagePath =item.content?.replaceAll("http://localhost/", SERVER_API_URL);
  }
  return Container(
      color: AppColors.primaryBackground,
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 250.w, minHeight: 40.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                        color: AppColors.primaryElement,
                        borderRadius: BorderRadius.circular(5.w)),
                    child: item.type == "text"
                        ? Text(
                            "${item.content}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.primaryElementText),
                          )
                        : ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 90.w),
                            child: GestureDetector(
                              child:
                                  CachedNetworkImage(imageUrl: imagePath!),
                              onTap: (){},
                            ),
                          ))
              ],
            ),
          )
        ],
      ));
}
