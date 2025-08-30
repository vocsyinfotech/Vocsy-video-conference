import 'package:video_conforance/utilitis/common_import.dart';

class ConstShimmer {
  static Widget profileImage({required double height, required double width, required double radius}) {
    return Shimmer.fromColors(
      baseColor: ConstColor.midGray.withValues(alpha: 0.3),
      highlightColor: ConstColor.lightGray.withValues(alpha: 0.3),
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius), color: ConstColor.darkGray),
      ),
    );
  }

  static Widget fetchMember({required double height, required double width, required double radius}) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
          child: Shimmer.fromColors(
            baseColor: ConstColor.midGray.withValues(alpha: 0.3),
            highlightColor: ConstColor.lightGray.withValues(alpha: 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: CircleAvatar(radius: 25.r, backgroundColor: Colors.grey[300]),
                    ),
                    SizedBox(width: 15.w),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 10.h,
                        width: 120.w,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey[300]),
                      ),
                    ),
                  ],
                ),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: CommonSvgView(iconPath: 'assets/icons/chat_message.svg', fit: BoxFit.cover, height: 28.h, color: Colors.grey[300]),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: 2,
    );
  }
}
