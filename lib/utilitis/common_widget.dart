import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:http/http.dart' as https;
// import 'package:intl/intl.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'common_import.dart';

double get commonHeight => MediaQuery.sizeOf(Get.context!).height;

double get commonWidth => MediaQuery.sizeOf(Get.context!).width;

// LOADING DIALOG


bool  isLoadingDialogOpen = false;

void showLoadingDialog(BuildContext context) {
  if (!isLoadingDialogOpen) {
    isLoadingDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      useSafeArea: true,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Lottie.asset('assets/animation/loading.json'),
          ),
        );
      },
    ).then((_) {
      isLoadingDialogOpen = false; // reset when closed
    });
  }
}

/*void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    useSafeArea: true,
    builder: (BuildContext context) {
      return Center(
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Lottie.asset('assets/animation/loading.json', height: 50.h),
        ),
      );
    },
  );
}*/

class CommonTextWidget extends StatelessWidget {
  final String title;
  final Color? color;
  final double? fontSize;
  final double? height;
  final int? maxLines;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final TextScaler? textScaler;
  final TextDirection? textDirection;
  final TextDecorationStyle? textDecorationStyle;
  final TextDecoration? textDecoration;
  final double? letterSpacing;
  final TextStyle? style;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const CommonTextWidget({
    super.key,
    required this.title,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.textOverflow,
    this.textScaler,
    this.maxLines,
    this.textDirection,
    this.textDecorationStyle,
    this.textDecoration,
    this.height,
    this.letterSpacing,
    this.style,
    this.onTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Text(
          title,
          textAlign: textAlign ?? TextAlign.start,
          overflow: textOverflow ?? TextOverflow.ellipsis,
          textScaler: textScaler ?? TextScaler.linear(1),
          maxLines: maxLines,
          textDirection: textDirection ?? TextDirection.ltr,
          softWrap: true,
          style:
              style ??
              TextStyle(
                color: color ?? ConstColor.darkGray,
                fontSize: fontSize ?? 14.sp,
                fontWeight: fontWeight ?? FontWeight.w400,
                fontFamily: fontFamily ?? "RR",
                decorationStyle:
                    textDecorationStyle ?? TextDecorationStyle.solid,
                decoration: textDecoration ?? TextDecoration.none,
                letterSpacing: letterSpacing,
                height: height,
              ),
        ),
      ),
    );
  }
}

class CommonButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? buttonColor;
  final double? radius;
  final double? height;
  final double? width;
  final double? textSize;
  final Widget? icon;

  const CommonButton({
    super.key,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.buttonColor,
    this.radius,
    this.height,
    this.width,
    this.textSize,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: icon,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? commonWidth, height ?? 55.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius ?? 15.r), // Rounded edges
        ),
        backgroundColor: buttonColor ?? ConstColor.blue,
      ),
      onPressed: onTap,
      label: CommonTextWidget(
        title: title,
        fontSize: textSize ?? 22.sp,
        fontFamily: "RSB",
        color: titleColor ?? ConstColor.blue,
      ),
    );
  }
}

class CommonContainer extends StatelessWidget {
  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color? containerColor;
  final double? radius;
  final double? height;
  final double? width;
  final Widget? child;

  const CommonContainer({
    super.key,
    required this.onTap,
    this.containerColor,
    this.radius,
    this.height,
    this.width,
    this.child,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 55.h,
        width: width ?? commonWidth,
        alignment: Alignment.center,
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 15.r),
          color: containerColor ?? ConstColor.lightBlue,
        ),
        child: child,
      ),
    );
  }
}

class CommonAppBar extends StatelessWidget {
  final Widget? leading;
  final List<Widget>? action;
  final String? title;
  final Color? titleColor;
  final Color? appBarColor;
  final double? leadingWidth;

  const CommonAppBar({
    super.key,
    this.leading,
    this.action,
    this.title,
    this.titleColor,
    this.appBarColor,
    this.leadingWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80.h,
      leadingWidth: leadingWidth,
      centerTitle: true,
      automaticallyImplyLeading: false,
      backgroundColor: appBarColor,
      leading: leading,
      elevation: 0,
      actions: action,
      title: CommonTextWidget(
        title: title ?? '',
        color: titleColor ?? ConstColor.white,
        fontSize: 18.sp,
        fontFamily: "RB",
      ),
    );
  }
}

class CommonDivider extends StatelessWidget {
  const CommonDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(color: ConstColor.lightGray.withValues(alpha: 0.1));
  }
}

class CommonTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final bool? isHideBorder;
  final bool? obscureText;
  final bool? isFiled;
  final Color? textColor;
  final Color? filedColor;
  final String? hintText;
  final EdgeInsets padding;
  final String? obscuringCharacter;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Function(String)? onChanged;

  const CommonTextFiled({
    super.key,
    required this.controller,
    this.isHideBorder,
    this.textColor,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    this.filedColor,
    this.prefixIcon,
    this.obscureText,
    this.isFiled,
    this.obscuringCharacter,
    this.onChanged,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      obscuringCharacter: obscuringCharacter ?? '*',
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(color: textColor, fontFamily: "RSB", fontSize: 16.sp),
      decoration: InputDecoration(
        filled: isFiled ?? false,
        fillColor: filedColor ?? Colors.transparent,
        contentPadding: EdgeInsets.all(18.sp),
        hint: CommonTextWidget(
          title: hintText ?? "",
          color: hintStyle?.color ?? ConstColor.lightGray.withValues(alpha: .5),
        ),
        border: isHideBorder == true
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide.none,
              )
            : OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

class CommonSvgView extends StatelessWidget {
  final String iconPath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final VoidCallback? onTap;

  const CommonSvgView({
    super.key,
    required this.iconPath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        iconPath,
        height: height,
        width: width,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
        fit: fit ?? BoxFit.contain,
        alignment: alignment ?? Alignment.center,
      ),
    );
  }
}

class CommonImageView extends StatelessWidget {
  const CommonImageView(
    this.path, {
    super.key,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.size,
    this.color,
    this.circle = false,
    this.border = false,
    this.radius,
    this.onTap,
    this.borderRadius,
  });

  final String path;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit fit;
  final bool circle;
  final bool border;
  final double? radius;
  final double? size;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: path,
      fit: BoxFit.cover,
      height: height ?? 200.w,
      width: width ?? 200.w,
      imageBuilder: (context, image) => InkWell(
        onTap: onTap,
        child: Container(
          height: height ?? 200.w,
          width: width ?? 200.w,
          decoration: circle
              ? BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: image, fit: fit),
                  border: border
                      ? Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2.w,
                        )
                      : null,
                )
              : BoxDecoration(
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(radius ?? 8.r),
                  border: border
                      ? Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2.w,
                        )
                      : null,
                  image: DecorationImage(image: image, fit: fit),
                ),
        ),
      ),
      placeholder: (context, url) => Container(
        height: height ?? 200.w,
        width: width ?? 200.w,
        alignment: Alignment.center,
        decoration: circle
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).hintColor,
              )
            : BoxDecoration(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(radius ?? 8.r),
                color: Theme.of(context).hintColor,
              ),
        child: Shimmer.fromColors(
          baseColor: ConstColor.white,
          highlightColor: ConstColor.lightGray,
          child: Icon(Icons.image, size: size),
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: height ?? 200.w,
        width: width ?? 200.w,
        decoration: circle
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
                image: DecorationImage(
                  image: const AssetImage('assets/png/Profile.png'),
                  fit: fit,
                ),
              )
            : BoxDecoration(
                borderRadius:
                    borderRadius ?? BorderRadius.circular(radius ?? 8.r),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
        child: circle ? null : Icon(Icons.image, size: size),
      ),
    );
  }
}

class AvatarListWidget extends StatefulWidget {
  final List<String> avatarList;

  const AvatarListWidget({super.key, required this.avatarList});

  @override
  State<AvatarListWidget> createState() => _AvatarListWidgetState();
}

class _AvatarListWidgetState extends State<AvatarListWidget> {
  List<UserAvatar> userAvatarList = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    List<UserAvatar> tempList = [];

    for (int i = 0; i < widget.avatarList.length && i < 3; i++) {
      final data = await fetchMeeting(widget.avatarList[i]);

      if (data != null) {
        String? base64Image = data['image'];
        String? name = data['username']; // Ensure name is fetched from response

        tempList.add(
          UserAvatar(
            name: name ?? '',
            imageBytes: base64Image != null ? base64Decode(base64Image) : null,
          ),
        );
      }
    }

    if (!mounted) return;
    setState(() {
      userAvatarList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    int maxVisible = 3;
    int extraCount = widget.avatarList.length - maxVisible;

    List<Widget> avatars = [];

    for (int i = 0; i < userAvatarList.length; i++) {
      // print('Name --- ${userAvatarList[i].name}');
      avatars.add(_buildAvatar(userAvatarList[i], i));
    }

    if (extraCount > 0) {
      avatars.add(_buildMoreCircle(extraCount, userAvatarList.length));
    }

    return SizedBox(
      height: 50.w,
      child: Stack(children: avatars),
    );
  }

  Widget _buildAvatar(UserAvatar user, int index) {
    return Positioned(
      left: index * 22.0,
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: user.imageBytes != null
            ? Colors.white
            : ConstColor.lightBlue,
        backgroundImage: user.imageBytes != null
            ? MemoryImage(user.imageBytes!)
            : null,
        child: user.imageBytes == null
            ? CommonTextWidget(
                title: _getInitials(user.name),
                fontFamily: 'RR',
                color: ConstColor.white,
                fontSize: 14.sp,
              )
            : null,
      ),
    );
  }

  Widget _buildMoreCircle(int count, int index) {
    return Positioned(
      left: index * 22.0,
      child: CircleAvatar(
        radius: 18.r,
        backgroundColor: const Color(0xff4E8D94),
        child: CommonTextWidget(
          title: '$count+',
          fontFamily: "RB",
          fontSize: 14.sp,
          color: ConstColor.white,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return "";
    List<String> parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}

class UserAvatar {
  final String name;
  final Uint8List? imageBytes;

  UserAvatar({required this.name, this.imageBytes});
}

PreferredSizeWidget commonAppBar({
  required String title,
  required Color titleColor,
  required Color bgColor,
  required Widget leadingWidget,
  required List<Widget> action,
  bool isLeadingWidgetIcon = false,
}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(80.h),
    child: AppBar(
      centerTitle: true,
      backgroundColor: bgColor,
      toolbarHeight: 80.h,
      automaticallyImplyLeading: false,
      leadingWidth: 80.w,
      leading: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: isLeadingWidgetIcon ? 0 : 15.sp),
        child: leadingWidget,
      ),
      title: Text(
        title,
        style: TextStyle(fontFamily: "RB", fontSize: 18.sp, color: titleColor),
      ),
      actions: action,
    ),
  );
}

class CommonSwitchRow extends StatelessWidget {
  final String text;
  final bool switchValue;
  final ValueChanged<bool> onChanged;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;

  const CommonSwitchRow({
    super.key,
    required this.text,
    required this.switchValue,
    required this.onChanged,
    this.color,
    this.fontFamily,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 14.sp,
            fontFamily: fontFamily ?? "RM",
            color: color ?? Theme.of(context).secondaryHeaderColor,
          ),
        ),
        CupertinoSwitch(value: switchValue, onChanged: onChanged),
      ],
    );
  }
}

// CALENDER DIALOG BOX
class CalendarDialog extends StatefulWidget {
  final ScheduleMeetingController controller;

  // final Function(DateTime) onDateSelected;
  const CalendarDialog({super.key, required this.controller});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  DateTime firstDay = DateTime.now().subtract(Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    _selectedDay = widget.controller.selectedDate.value ?? DateTime.now();
    return SizedBox(
      width: commonWidth,
      child: TableCalendar(
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        ),
        lastDay: DateTime.utc(2100, 12, 31),
        calendarFormat: CalendarFormat.month,
        startingDayOfWeek: StartingDayOfWeek.sunday,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          // setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
          widget.controller.selectedDate.value = _selectedDay;
          widget.controller.isShowDatePiker.value = false;
          // });
          // print('Seleced DSA :::: ${widget.controller.selectedDate.toString()}');
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        headerVisible: true,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: false,
          titleTextStyle: TextStyle(
            fontSize: 18.sp,
            fontFamily: "RM",
            color: Theme.of(
              context,
            ).secondaryHeaderColor.withValues(alpha: 0.5),
          ),
        ),
        calendarStyle: CalendarStyle(
          weekendTextStyle: TextStyle(
            fontFamily: "RB",
            fontSize: 15.sp,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          defaultTextStyle: TextStyle(
            fontFamily: "RB",
            fontSize: 15.sp,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          todayTextStyle: TextStyle(
            fontFamily: "RB",
            fontSize: 15.sp,
            color: Theme.of(context).secondaryHeaderColor,
          ),
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.3),
            ),
          ),
          selectedDecoration: BoxDecoration(
            color: ConstColor.lightBlue,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            fontFamily: "RB",
            fontSize: 15.sp,
            color: Colors.white,
          ),
          outsideDaysVisible: false,
        ),
        enabledDayPredicate: (day) {
          final today = DateTime.now();
          final justToday = DateTime(today.year, today.month, today.day);
          return !day.isBefore(justToday);
        },
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontFamily: "RM",
            fontSize: 15.sp,
            color: Theme.of(
              context,
            ).secondaryHeaderColor.withValues(alpha: 0.5),
          ),
          weekendStyle: TextStyle(
            fontFamily: "RM",
            fontSize: 15.sp,
            color: Theme.of(
              context,
            ).secondaryHeaderColor.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}

// TIME PIKER BOX
class TimeDialog extends StatefulWidget {
  final ScheduleMeetingController controller;

  // final Function(DateTime) onDateSelected;
  const TimeDialog({super.key, required this.controller});

  @override
  State<TimeDialog> createState() => _TimeDialogState();
}

class _TimeDialogState extends State<TimeDialog> {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final minTime = now.add(const Duration(minutes: 29));
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.time,
      initialDateTime: DateTime(
        0,
        0,
        0,
        widget.controller.selectedTime.value != null
            ? widget.controller.selectedTime.value!.hour
            : minTime.hour,
        widget.controller.selectedTime.value != null
            ? widget.controller.selectedTime.value!.minute
            : minTime.minute,
      ),
      use24hFormat: false,
      onDateTimeChanged: (DateTime newTime) {
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          newTime.hour,
          newTime.minute,
        );

        if (selectedDateTime.isBefore(minTime)) {
          widget.controller.isValidTime.value = false;
          return;
        }
        widget.controller.isValidTime.value = true;
        // setState(() {
        widget.controller.selectedTime.value = TimeOfDay(
          hour: newTime.hour,
          minute: newTime.minute,
        );
        // });
      },
    );
  }
}

// PHONE FORM FIELD
class PhoneFormField extends StatelessWidget {
  const PhoneFormField({
    super.key,
    required this.mobileController,
    required this.initialCountryCode,
    required this.onCountryChanged,
    this.onChanged,
  });

  final TextEditingController mobileController;
  final String initialCountryCode;
  final Function(Country)? onCountryChanged;
  final Function(PhoneNumber)? onChanged;

  @override
  Widget build(BuildContext context) {
    debugPrint('MOBILE VALIDATION IS *** ${mobileController.value.text} ***');
    return IntlPhoneField(
      controller: mobileController,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autovalidateMode: AutovalidateMode.always,
      style: TextStyle(
        fontSize: 16.sp,
        color: Theme.of(context).secondaryHeaderColor,
        fontFamily: 'RM',
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 20.sp,
          horizontal: 20.sp,
        ),
        filled: true,
        fillColor: Theme.of(context).cardColor,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        hintText: 'Enter your mobile number'.tr,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).secondaryHeaderColor.withValues(alpha: 0.5),
          fontFamily: 'RM',
        ),
        errorStyle: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xffDE2424),
          fontFamily: 'RM',
        ),
      ),
      pickerDialogStyle: PickerDialogStyle(
        searchFieldInputDecoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              width: 1.w,
              color: Theme.of(
                context,
              ).secondaryHeaderColor.withValues(alpha: 0.5),
            ),
          ),
          hintText: 'Search'.tr,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(
              context,
            ).secondaryHeaderColor.withValues(alpha: 0.5),
            fontFamily: 'RM',
          ),
          errorStyle: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xffDE2424),
            fontFamily: 'RM',
          ),
        ),
        countryNameStyle: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).secondaryHeaderColor,
          fontFamily: 'RB',
        ),
        countryCodeStyle: TextStyle(
          fontSize: 14.sp,
          color: Theme.of(context).secondaryHeaderColor,
          fontFamily: 'RR',
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      keyboardType: Platform.isIOS
          ? const TextInputType.numberWithOptions(signed: true)
          : TextInputType.number,
      initialCountryCode: initialCountryCode,
      showCountryFlag: false,
      textInputAction: TextInputAction.next,
      dropdownIconPosition: IconPosition.trailing,
      dropdownTextStyle: TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
      ),
      onChanged: onChanged,
      validator: (value) {
        debugPrint('MOBILE VALIDATION IS *** ${mobileController.text} ***');
        if (value == null || value.number.isEmpty) {
          debugPrint('MOBILE VALIDATION IS EMPTY');
          return "${"Mobile_No".tr} ${"is_required".tr}";
        }
        debugPrint('MOBILE VALIDATION IS *** ${mobileController.text} ***');
        return null;
      },
      onCountryChanged: onCountryChanged,
    );
  }
}

// CUSTOM SNACK BAR
customSnackBar(String title, String msg) {
  return Get.snackbar(
    title,
    msg,
    backgroundColor: ConstColor.lightBlue.withValues(alpha: 0.5),
    borderRadius: 10,
    padding: EdgeInsets.all(8.r),
    colorText: ConstColor.white,
  );
}

// STRING TO HEX FOR PASS
String stringToHex(String input) {
  return input.codeUnits
      .map((char) => char.toRadixString(16).padLeft(2, '0'))
      .join();
}

// IF IMAGE IS NOT PIKED THEN SHOW
String getUserInitials(String username) {
  final parts = username.trim().split(' ');
  if (parts.length >= 2) {
    // Username has a space
    return '${parts[0][0].toUpperCase()}${parts[1][0].toUpperCase()}';
  } else if (username.length >= 2) {
    // No space, take first two letters
    return '${username[0].toUpperCase()}${username[1].toUpperCase()}';
  } else if (username.isNotEmpty) {
    // Only one character
    return username[0].toUpperCase();
  } else {
    return '';
  }
}

// GET TIME ZONE LIST

void initTimeZones() {
  tz.initializeTimeZones();
  final locations = tz.timeZoneDatabase.locations;
  locations.forEach((key, value) {
    print(key); // This prints all time zone names like 'Asia/Kolkata', etc.
  });
}

// GENERATE MEETING ID
String generateMeetingId({int length = 10}) {
  final rand = Random();
  String id = '';
  for (int i = 0; i < length; i++) {
    id += rand.nextInt(10).toString(); // 0–9 digits
  }
  return id;
}

// GENERATE PASS CODE
String generatePasscode({int length = 8}) {
  const chars =
      'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789'; // Removed confusing chars like 0, O, l, 1
  final rand = Random();
  return List.generate(length, (_) => chars[rand.nextInt(chars.length)]).join();
}

// COPY TEXT
void copyText(String fullTextToCopy) {
  Clipboard.setData(ClipboardData(text: fullTextToCopy));
}

Future<Map<String, dynamic>?> fetchMeeting(String docId) async {
  // print('🚆 $docId');
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(docId)
      .get();
  return doc.data() as Map<String, dynamic>?;
}

/// SEND THE EMAIL INVITATION

Future<void> sendInviteEmail({
  required String recipientEmail,
  required String meetingId,
}) async {
  try {
    // Configure your SMTP server
    print('EEE --- $recipientEmail  && MeetingId is Following :: $meetingId');
    var docId = 'group_${MessageService().currentUserId}';
    print('👓👓👓👓👓👓 $docId 👓👓👓👓👓');
    String acceptLink = await createDynamicLink(
      action: "accept",
      meetingId: meetingId,
      docId: docId,
    );
    String rejectLink = await createDynamicLink(
      action: "reject",
      meetingId: meetingId,
      docId: docId,
    );

    final smtpServer = gmail("krunalvocsy@gmail.com", 'kcfo cfol bzln tneo');

    final message = Message()
      ..from = Address('vocsysamsung@gmail.com', 'Video Conference')
      ..recipients.add(recipientEmail)
      ..subject = 'Join our Meeting Invitation'
      ..html =
          '''
      <h2>You're invited to join our meeting!</h2>
      <p>Hi there,</p>
      <p>You have been invited to join a video meeting.</p>

      <p>
        <a href="$acceptLink"
           style="padding: 10px 20px; background-color: #4CAF50; color: white; text-decoration: none; border-radius: 5px;">
           Accept
        </a>

        &nbsp;

        <a href= "$rejectLink"
           style="padding: 10px 20px; background-color: #f44336; color: white; text-decoration: none; border-radius: 5px;">
           Reject
        </a>
      </p>

      <p>If you have any questions, please contact us.</p>
    ''';

    // Send the email
    await send(message, smtpServer);
  } catch (e) {
    print('Error launching email: $e');
  }
}

// CREATE DYNAMIC LINK
String link = 'https://videoconforance.page.link';

Future<String> createDynamicLink({
  required String action,
  required String meetingId,
  required String docId,
}) async {
  try {
    print('########## $docId🎁🎁🎁');
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: link,
      link: Uri.parse("$link/invite?action=$action&id=$meetingId&docId=$docId"),
      androidParameters: const AndroidParameters(
        packageName: "com.vocsy.video_conforance",
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        appStoreId: "6741185061",
        bundleId: "com.vocsy.video_conforance",
        minimumVersion: "0",
      ),
    );
    print('Deep link create parameters');
    final dynamicLink = await FirebaseDynamicLinksPlatform.instance.buildLink(
      parameters,
    );
    debugPrint('Deep Link Data: ${dynamicLink.toString()}');
    return dynamicLink.toString();
  } catch (e) {
    print('ERROR TO CREATE LINK :: $e');
    return "";
  }
}

// INIT LINK

PendingDynamicLinkData? initialLink;
FirebaseDynamicLinksPlatform dynamicLinks =
    FirebaseDynamicLinksPlatform.instance;

/// 👇 Call this once when the app starts (e.g., inside SplashScreen or MainScreen initState)
Future<void> initDynamicLinks() async {
  // 1️⃣ Handle when app is opened from terminated state (cold start)
  initialLink = await dynamicLinks.getInitialLink();

  if (initialLink != null) {
    final Uri deepLink = initialLink!.link;
    await _handleLink(deepLink);
  }

  // 2️⃣ Handle when app is already running (background or foreground)
  dynamicLinks.onLink
      .listen((dynamicLinkData) {
        final Uri deepLink = dynamicLinkData.link;
        _handleLink(deepLink);
      })
      .onError((e) {
        debugPrint("❌ Dynamic link error: $e");
      });
}

/// 🔁 Common link handler
Future<void> _handleLink(Uri deepLink) async {
  debugPrint("🌐 Received deep link: ${deepLink.toString()}");
  final meetingId = deepLink.queryParameters["id"];
  final action = deepLink.queryParameters["action"];
  // final senderId = deepLink.queryParameters["senderId"];
  final docId = deepLink.queryParameters["docId"];
  debugPrint('📌 Event Id: $meetingId, Organizer Id: $action $docId');
  if (action != null && meetingId != null) {
    if (action == 'accept') {
      print('SUCCESSFULLY ACCEPT INVITATION $meetingId');
      AuthService().addParticipant(meetingId: meetingId);
      MessageService().inviteMemberInGroup(docId.toString());
      customSnackBar('Success', "Successfully accept invitation");
    } else if (action == 'invite') {
      print('SUCCESSFULLY INVITATION FOR JOIN MEETING $meetingId');
    } else {
      print('SUCCESSFULLY REJECT INVITATION $meetingId');
      customSnackBar('Success', 'Successfully reject invitation');
    }
  }
}

/// MESSAGE

Widget buildMessageBubble(
  ChatMessage message,
  bool isMe,
  Color color,
  String receiverId,
) {
  if (!isMe) MessageService().markAllMessagesAsRead(receiverId);
  return Column(
    crossAxisAlignment: isMe
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start,
    children: [
      Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: message.type.name == 'image'
              ? EdgeInsets.all(3.sp)
              : EdgeInsets.all(12.sp),
          decoration: BoxDecoration(
            color: isMe ? ConstColor.lightBlue : ConstColor.white,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
          ),
          child: _buildContent(message, isMe),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 2),
        child: CommonTextWidget(
          title: formatTime(message.timestamp ?? DateTime.now()),
          // Implement formatting
          fontSize: 12.sp,
          fontFamily: "RM",
          color: color.withValues(alpha: 0.5),
        ),
      ),
    ],
  );
}

Widget buildGroupMessageBubble(
  ChatMessage message,
  bool isMe,
  Color color,
  String groupId,
) {
  if (!isMe) MessageService().markAllGroupMessagesAsRead(groupId);
  return Row(
    mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!isMe)
        FutureBuilder(
          future: AuthService().getUserDataById(message.senderId),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final senderName = snapshot.data?.username ?? '...';
              Uint8List? bytes = snapshot.data!.image == null
                  ? null
                  : base64Decode(snapshot.data!.image.toString());
              return Padding(
                padding: EdgeInsets.only(left: 8.sp),
                child: CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.blueAccent,
                  backgroundImage: (bytes != null && bytes.isNotEmpty)
                      ? MemoryImage(bytes)
                      : null,
                  child: (bytes == null || bytes.isEmpty)
                      ? CommonTextWidget(
                          title: senderName
                              .toString()
                              .substring(0, 2)
                              .toUpperCase(),
                          fontFamily: "RSB",
                          fontSize: 12.sp,
                          color: ConstColor.white,
                        )
                      : null,
                ),
              );
            }
            return SizedBox.shrink();
          },
        ),
      Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: message.type.name == 'image'
                  ? EdgeInsets.all(3.sp)
                  : EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: isMe ? ConstColor.lightBlue : ConstColor.white,
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(10.r),
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(10.r),
                        bottomLeft: Radius.circular(10.r),
                        bottomRight: Radius.circular(10.r),
                      ),
              ),
              child: Column(children: [_buildContent(message, isMe)]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 2),
            child: CommonTextWidget(
              title: formatTime(message.timestamp ?? DateTime.now()),
              // Implement formatting
              fontSize: 12.sp,
              fontFamily: "RM",
              color: color.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget liveMeetingChatMessageBubble(
  ChatMessage message,
  bool isMe,
  Color color,
  String groupId,
) {
  if (!isMe) MessageService().markAllGroupMessagesAsRead(groupId);
  return FutureBuilder(
    future: AuthService().getUserDataById(message.senderId),
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data != null) {
        final senderName = snapshot.data?.username ?? '...';
        Uint8List? bytes = snapshot.data!.image == null
            ? null
            : base64Decode(snapshot.data!.image.toString());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.sp),
              child: CommonTextWidget(
                title: senderName,
                fontFamily: "RR",
                fontSize: 12.sp,
                color: ConstColor.white.withValues(alpha: 0.2),
              ),
            ),
            SizedBox(height: 5.h),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 8.sp,
                    right: 5.sp,
                    bottom: 5.sp,
                  ),
                  child: Container(
                    height: 40.h,
                    width: 40.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      color: ConstColor.lightBlue,
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: (bytes != null && bytes.isNotEmpty)
                        ? Image.memory(
                            bytes,
                            height: 40.h,
                            width: 40.h,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: CommonTextWidget(
                              title: senderName
                                  .toString()
                                  .substring(0, 2)
                                  .toUpperCase(),
                              fontFamily: "RSB",
                              fontSize: 12.sp,
                              color: ConstColor.white,
                            ),
                          ),
                  ),
                ),
                SizedBox(width: 8.w), // 👈 spacing between avatar & text
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildContent(message, true)],
                  ),
                ),
              ],
            ),
          ],
        );
      }
      return SizedBox.shrink();
    },
  );
}

class ImageMessageWidget extends StatefulWidget {
  final Uint8List bytes;
  final bool isMe;
  final String fileName;

  const ImageMessageWidget({
    Key? key,
    required this.bytes,
    required this.isMe,
    required this.fileName,
  }) : super(key: key);

  @override
  _ImageMessageWidgetState createState() => _ImageMessageWidgetState();
}

class _ImageMessageWidgetState extends State<ImageMessageWidget> {
  bool? _isDownloaded;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: isMediaAlreadyDownloaded(
        fileName: widget.fileName,
        isVideo: false,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();

        // Use local state if available, otherwise use initial check
        bool isDownloaded = _isDownloaded ?? (snapshot.data! || widget.isMe);

        return GestureDetector(
          onTap: () async {
            if (!isDownloaded) {
              await saveMediaToAppFolder(
                bytes: widget.bytes,
                context: context,
                isVideo: false,
              );
              setState(() => _isDownloaded = true);
            }
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: !isDownloaded
                    ? Image.memory(
                        widget.bytes,
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.red),
                      ).blurred(
                        blur: 5,
                        blurColor: Colors.white,
                        overlay: Container(
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      )
                    : Image.memory(
                        widget.bytes,
                        width: 120.w,
                        height: 120.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.broken_image, color: Colors.red),
                      ),
              ),
              if (!isDownloaded)
                Icon(Icons.file_download_outlined, color: Colors.white),
            ],
          ),
        );
      },
    );
  }
}

// Updated _buildContent method
Widget _buildContent(ChatMessage message, bool isMe) {
  switch (message.type) {
    case MessageType.text:
      return CommonTextWidget(
        title: message.text,
        fontFamily: "RM",
        fontSize: 14.sp,
        color: isMe ? Colors.white : Colors.black,
        maxLines: 10000,
      );

    case MessageType.image:
      final bytes = base64Decode(message.text);
      final fileName = getFileNameFromBytes(bytes, isVideo: false);
      return ImageMessageWidget(bytes: bytes, isMe: isMe, fileName: fileName);

    case MessageType.file:
      return GestureDetector(
        onTap: () => launchUrl(Uri.parse(message.text)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.attach_file, color: isMe ? Colors.white : Colors.black),
            SizedBox(width: 8),
            Text(
              'Open File',
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      );
  }
}

// SAVE IMAGE IN TO STORAGE
Future<void> saveMediaToAppFolder({
  required Uint8List bytes,
  required bool isVideo,
  required BuildContext context,
}) async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidInfo = await deviceInfoPlugin.androidInfo;
  debugPrint('🚍  ${androidInfo.version.sdkInt.toInt()}');
  if (androidInfo.version.sdkInt.toInt() < 33) {
    final status = await Permission.storage.request();
    if (status.isDenied) return;
  }
  print('DOWNLOADING');
  try {
    // Get Android root Download path
    final baseDir = Directory(
      '/storage/emulated/0/Download/VideoConference',
    ); // Change to your app's name

    final subDir = isVideo ? 'Videos' : 'Images';
    final targetDir = Directory('${baseDir.path}/$subDir');

    // Create directory if it doesn't exist
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final fileName = getFileNameFromBytes(bytes, isVideo: false);

    final file = File('${targetDir.path}/$fileName');

    // Write file if it doesn't exist
    if (!await file.exists()) {
      await file.writeAsBytes(bytes);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${isVideo ? "Video" : "Image"} saved")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("File already exists")));
    }
  } catch (e) {
    print('ERROR TO DOWNLOAD $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error saving file: $e")));
  }
}

String getFileNameFromBytes(Uint8List bytes, {required bool isVideo}) {
  final hash = sha1.convert(bytes).toString();
  return isVideo ? '$hash.mp4' : '$hash.jpg';
}

Future<bool> isMediaAlreadyDownloaded({
  required String fileName,
  required bool isVideo,
}) async {
  // Define your base app folder
  final baseDir = Directory(
    '/storage/emulated/0/Download/VideoConference',
  ); // Change to your app name

  // Choose subfolder based on type
  final subDir = isVideo ? 'Videos' : 'Images';

  // Build full path to the file
  final filePath = '${baseDir.path}/$subDir/$fileName';

  // Create File object
  final file = File(filePath);

  // Return true if file exists
  return await file.exists();
}

// TIME AGO SHOW
String timeAgo(DateTime dateTime) {
  final Duration diff = DateTime.now().difference(dateTime);

  if (diff.inSeconds < 60) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
  if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
  return '${(diff.inDays / 365).floor()}y ago';
}

String formatTime(DateTime date) {
  final time = TimeOfDay.fromDateTime(date);
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? 'AM' : 'PM';
  return '$hour:$minute $period';
}

// PIKE IMAGE
Future<String?> pickImage({int i = 0}) async {
  final pickedFile = await ImagePicker().pickImage(
    source: i == 1 ? ImageSource.camera : ImageSource.gallery,
    imageQuality: 30,
  );
  if (pickedFile != null) {
    final imageBytes = await File(pickedFile.path).readAsBytes();
    final base64 = base64Encode(imageBytes);
    return base64;
  }
  return null;
}

// PIKE MULTIPLE IMAGE
Future<List<String>?> pickMultipleImage() async {
  List<String> bytesList = [];
  final pickedFiles = await ImagePicker().pickMultiImage(
    imageQuality: 70,
    limit: 10,
  );
  if (pickedFiles.isNotEmpty) {
    for (XFile pickedFile in pickedFiles) {
      final imageBytes = await File(pickedFile.path).readAsBytes();
      final base64 = base64Encode(imageBytes);
      bytesList.add(base64);
    }
    return bytesList;
  }
  return null;
}

// PIKE DOCUMENT FILE
Future<void> pikeDocument() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: true,
    type: FileType.custom,
    allowedExtensions: ['jpg', 'pdf', 'doc', 'png', 'apk', 'txt'],
  );
  if (result != null) {
    print("Document Length: ${result.files.length}");
    for (var path in result.files) {
      print('BYTES IS ${path.bytes}');
      print('BYTES IS ${path.size}');
      print('BYTES IS ${path.path}');
      print('BYTES IS ${path.name}');
    }
  }
}

// GET PUSH TOKEN
void getPushToken() {
  FirebaseMessaging.instance.getToken().then((value) {
    CommonVariable.pushToken.value = value ?? '';
    debugPrint(' 🏯 ${CommonVariable.pushToken.value}');
  });
}

// EMOJI POPUP
class EmojiReactionPopup extends StatelessWidget {
  final Function(String emoji) onEmojiSelected;

  const EmojiReactionPopup({super.key, required this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    List<String> emojis = ['❤️', '😂', '😮', '😢', '👍', '👎'];

    return Material(
      elevation: 4,
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: emojis
              .map(
                (emoji) => GestureDetector(
                  onTap: () => onEmojiSelected(emoji),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(emoji, style: TextStyle(fontSize: 24)),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// GENERATE AGORA CALLING TOKEN
Future<String> generateToken(String channelName) async {
  String uri =
      'https://agora-token-generator-demo.vercel.app/api/main?type=rtc';
  Map<String, dynamic> body = {
    "appId": "9af0e9f912e143939a3e7f400f51bec6",
    "certificate": "d6ebd659b607450c9e060acec43813e8",
    // SECOND CERTIFICATE c00fa1e93eb74203bf752511792c65ac
    "channel": channelName,
    "uid": "0",
    "role": "publisher",
    "expire": 3600,
  };
  String jsonBody = json.encode(body);
  Map<String, String> headers = {"Content-Type": "application/json"};
  final response = await https.post(
    Uri.parse(uri),
    body: jsonBody,
    headers: headers,
  );
  final decodeData = jsonDecode(response.body);
  return decodeData['rtcToken'];
}

int stringToInt() {
  var id = int.parse(
    (Random().nextInt(1000000000) * 10 + Random().nextInt(10))
        .toString()
        .padLeft(10, '0'),
  );
  return id;
}
