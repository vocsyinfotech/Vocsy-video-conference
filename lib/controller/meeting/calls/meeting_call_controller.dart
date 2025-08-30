import 'package:video_conforance/utilitis/common_import.dart';

class MeetingCallController extends GetxController {
  RxBool isMute = RxBool(false);
  RxBool isStopVideo = RxBool(false);
  var chatBoatController = TextEditingController().obs;

  RxList<ParticipantsModel> participantsList = RxList([
    ParticipantsModel(name: 'Vocsy Designer (Host)', imageUrl: 'https://cdn.pixabay.com/photo/2024/09/10/19/04/ai-9037925_640.png'),
    ParticipantsModel(name: 'Akex Xender', imageUrl: 'https://cdn.pixabay.com/photo/2024/04/07/18/39/woman-8682003_640.png'),
  ]);

  void endCall(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColor.darkGray,
      builder: (context) {
        return Container(
          height: 200.h,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonContainer(
                onTap: () {},
                height: 60.h,
                containerColor: ConstColor.red,
                child: CommonTextWidget(title: 'End Meeting'.tr, fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
              ),
              SizedBox(height: 8.h),
              CommonContainer(
                onTap: () => Get.back(),
                height: 60.h,
                containerColor: ConstColor.white.withValues(alpha: 0.1),
                child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  void participantsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColor.darkGray,
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Align(
                alignment: Alignment.center,
                child: CommonTextWidget(title: '${'Participants'.tr}(2)', fontSize: 20.sp, fontFamily: "RB", color: ConstColor.white),
              ),
              SizedBox(height: 15.h),
              Divider(color: ConstColor.white.withValues(alpha: 0.1)),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CommonTextWidget(
                      title: 'Waiting Participants',
                      fontSize: 12,
                      fontFamily: "RR",
                      color: ConstColor.white.withValues(alpha: 0.1),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: 10.w),
                          CommonContainer(
                            onTap: () {},
                            height: 50.w,
                            width: 50.w,
                            containerColor: ConstColor.lightBlue,
                            radius: 5.r,
                            child: CommonTextWidget(title: "MR", fontFamily: "RB", fontSize: 16.sp, color: ConstColor.white),
                          ),
                          SizedBox(width: 10.w),
                          CommonTextWidget(title: 'Maria Rexod', fontSize: 16.sp, fontFamily: "RM", color: ConstColor.white),
                          SizedBox(width: 20.w),
                        ],
                      ),
                      Row(
                        children: [
                          CommonContainer(
                            onTap: () {},
                            height: 30.w,
                            width: 70.w,
                            containerColor: ConstColor.red,
                            radius: 5.r,
                            child: CommonTextWidget(title: 'Cancel'.tr, fontSize: 12.sp, fontFamily: "RR", color: ConstColor.white),
                          ),
                          SizedBox(width: 10.w),
                          CommonContainer(
                            onTap: () {},
                            height: 30.w,
                            width: 70.w,
                            radius: 5.r,
                            containerColor: ConstColor.lightBlue,
                            child: CommonTextWidget(title: 'Accept'.tr, fontSize: 12.sp, fontFamily: "RR", color: ConstColor.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: ConstColor.white.withValues(alpha: 0.1), height: 30.h),
                  SizedBox(height: 20.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        height: 75.h,
                        padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Color(0xff191919)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 55.w,
                                  width: 55.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    image: DecorationImage(image: NetworkImage('${participantsList[index].imageUrl}'), fit: BoxFit.cover),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                CommonTextWidget(
                                  title: '${participantsList[index].name}',
                                  fontFamily: "RM",
                                  fontSize: 16.sp,
                                  color: ConstColor.white,
                                ),
                              ],
                            ),
                            CommonSvgView(
                              iconPath: 'assets/icons/chat_message.svg',
                              height: 28.w,
                              width: 28.w,
                              fit: BoxFit.cover,
                              color: ConstColor.white.withValues(alpha: 0.45),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10.h),
                    itemCount: participantsList.length,
                  ),
                ],
              ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
              CommonContainer(
                onTap: () {},
                height: 55.h,
                child: CommonTextWidget(title: 'Invite'.tr, color: ConstColor.white, fontSize: 18.sp, fontFamily: "SB"),
              ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
              SizedBox(height: 20.h),
            ],
          ),
        );
      },
    );
  }

  void chatBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ConstColor.darkGray,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.center,
                  child: CommonTextWidget(title: 'Chat', fontSize: 20.sp, fontFamily: "RB", color: ConstColor.white),
                ),
                SizedBox(height: 15.h),
                Divider(color: ConstColor.white.withValues(alpha: 0.1)),
                Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: EdgeInsets.only(left: 10.sp, right: 10.sp, top: 10.sp, bottom: 10.sp),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CommonTextWidget(
                                    title: 'Me (Host)',
                                    color: ConstColor.white.withValues(alpha: 0.3),
                                    fontSize: 12.sp,
                                    fontFamily: "RR",
                                  ),
                                  SizedBox(height: 3.h),
                                  Container(
                                    height: 55.w,
                                    width: 55.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(image: NetworkImage('${participantsList[index].imageUrl}'), fit: BoxFit.cover),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: CommonTextWidget(
                                  title: 'I don\'t know why people are so anti pineapple pizza. I kind of like it.',
                                  fontFamily: "RM",
                                  fontSize: 12.sp,
                                  maxLines: 2,
                                  color: ConstColor.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(height: 10.h),
                      itemCount: participantsList.length,
                    ),
                  ],
                ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
                Row(
                  children: [
                    Expanded(
                      child: CommonTextFiled(
                        controller: chatBoatController.value,
                        filedColor: ConstColor.white.withValues(alpha: 0.02),
                        isFiled: true,
                        isHideBorder: true,
                        hintText: "Write your message",
                        hintStyle: TextStyle(fontSize: 12.sp, fontFamily: "RM", color: ConstColor.white.withValues(alpha: 0.3)),
                      ),
                    ),
                    SizedBox(width: 15.sp),
                    CommonSvgView(iconPath: 'assets/icons/send.svg', height: 40.w, width: 40.w, fit: BoxFit.cover),
                  ],
                ).paddingSymmetric(vertical: 15.sp, horizontal: 15.sp),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ParticipantsModel {
  String? imageUrl;
  String? name;
  ParticipantsModel({this.name, this.imageUrl});
}
