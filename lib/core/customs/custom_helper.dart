import 'dart:ui';
import 'package:intl/intl.dart';

import '../../app.dart';

// SHIMMER
Widget customShimmer({double? height, double? width, double? borderRadius}) {
  return Shimmer.fromColors(
    baseColor: AppColor.black2,
    highlightColor: AppColor.black1,
    child: Container(
      height: height ?? 1.sh,
      width: width ?? 1.sw,
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
    ),
  );
}

// BLUR
Widget blurEffect(double blurValue, Widget child,
    {BorderRadius borderRadius = BorderRadius.zero}) {
  return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
          child: child));
}

// FORMAT WORK HOURS
String formatWorkHours(dynamic totalHours, {bool clockFormat = false}) {
  totalHours ??= 0;
  if(totalHours is DateTime) {
    return DateFormat('hh:mm a').format(totalHours);
  }

  if (clockFormat) {
    return '${totalHours ~/ 60} : ${totalHours % 60} : 00';
  }
  return '${totalHours ~/ 60} Hrs ${totalHours % 60} Mins';
}

// BUILD TITLE
Widget buildTitle(String title, {String? subtitle, void Function()? event}) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    CustomText(text: title, weight: FontWeight.w600, size: 16.w),
    if (subtitle != null) ...[
      SizedBox(width: 4.w),
      CustomText(text: subtitle, color: Colors.grey.shade700)
    ],
    const Spacer(),
    if (event != null)
      CustomButton(
          buttonType: ButtonType.ICON,
          buttonNature: ButtonNature.BOUNDED,
          icon: AppSvgs.ARROW_RIGHT,
          forgroundColor: Colors.grey.shade700,
          onPressed: event)
  ]).paddingSymmetric(horizontal: 16.w, vertical: 8.w);
}

AppBar customAppBar(BuildContext context, {String? title}) {
  return AppBar(
      backgroundColor: AppColor.blue_1,
      surfaceTintColor: Colors.transparent,
      leading: CustomImage(
        imageType: ImageType.SVG_LOCAL,
        imageUrl: AppSvgs.ARROW_LEFT,
        color: AppColor.white.withAlpha(200),
        onClick: () => context.pop(),
      ).paddingSymmetric(vertical: 8.w),
      title: CustomText(
          text: title ?? "",
          weight: FontWeight.w600,
          color: AppColor.white.withAlpha(200),
          size: 18.w));
}
