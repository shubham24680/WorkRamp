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
  if (totalHours is DateTime) {
    return DateFormat('hh:mm a').format(totalHours);
  }

  final hr = (totalHours ~/ 60).toString().padLeft(2, '0');
  final min = (totalHours % 60).toString().padLeft(2, '0');

  if (clockFormat) {
    return '$hr : $min : 00';
  }
  return '$hr Hrs $min Mins';
}

// BUILD TITLE
Widget buildTitle(String title, {String? subtitle, void Function()? event}) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    CustomText(
        text: title, weight: FontWeight.w600, color: Colors.grey.shade700),
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
  ]).paddingSymmetric(horizontal: 24.w, vertical: 8.w);
}

// APP BAR
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
      centerTitle: true,
      title: CustomText(
          text: title ?? "",
          weight: FontWeight.w600,
          color: AppColor.white.withAlpha(200),
          size: 18.w));
}

// SUMMARY
Widget buildSummary(List<SummaryModel> summary) {
  return CustomContainer(
      color: Colors.white,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
      padding: EdgeInsets.symmetric(vertical: 8.w),
      borderRadius: BorderRadius.circular(25.r),
      shadowColor: Colors.black.withAlpha(25),
      blurRadius: 10.0,
      child: GridView.builder(
          itemCount: summary.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 8.w, childAspectRatio: 1.25),
          itemBuilder: (context, index) {
            final total = summary[index].value.toString().padLeft(2, "0");

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomContainer(
                    color: summary[index].color.shade100,
                    padding:
                        EdgeInsets.symmetric(vertical: 4.w, horizontal: 8.w),
                    borderRadius: BorderRadius.circular(8.r),
                    child: CustomText(
                        text: total,
                        color: summary[index].color.shade700,
                        weight: FontWeight.w600,
                        size: 16.w)),
                SizedBox(height: 4.w),
                CustomText(
                    text: summary[index].name,
                    align: TextAlign.center,
                    maxLines: 2)
              ],
            );
          }));
}

// TRANSACTION
Widget buildTransaction(TransactionModel transaction) {
  final chip = transaction.chip;
  final dates = transaction.dates;
  final bottomText = transaction.bottomText;

  return CustomContainer(
      color: Colors.white,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.w),
      padding: EdgeInsets.all(16.w),
      borderRadius: BorderRadius.circular(25.r),
      shadowColor: Colors.black.withAlpha(25),
      blurRadius: 10.0,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (chip != null)
              Row(
                  children: chip.map((chip) {
                if (chip.title == null) {
                  return Spacer();
                }

                return CustomChip(
                        label: chip.title ?? "",
                        backgroundColor:
                            chip.color?.shade100 ?? AppColor.blue_14,
                        textColor: chip.color?.shade700 ?? AppColor.blue_3)
                    .paddingSymmetric(horizontal: 4.w);
              }).toList()),
            if (dates != null) ...[
              SizedBox(height: 8.w),
              Row(children: dates.map((e) => inOrOut(e)).toList()),
            ],
            if (bottomText != null) ...[
              SizedBox(height: 8.w),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                CustomImage(
                    imageType: ImageType.SVG_LOCAL,
                    imageUrl: transaction.icon ?? AppSvgs.LOCATION,
                    color: Colors.grey.shade700,
                    height: 12.w),
                SizedBox(width: 4.w),
                Flexible(
                    child: CustomText(
                        text: bottomText,
                        color: Colors.grey.shade700,
                        size: 10.w))
              ])
            ]
          ]));
}

Widget inOrOut(List<String> info) {
  return info.isEmpty
      ? CustomText(text: "|", color: Colors.grey.shade100, size: 24.w)
      : Expanded(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
          CustomText(text: info[0], size: 10.w, color: Colors.grey.shade700),
          SizedBox(height: 4.w),
          CustomText(text: info[1], weight: FontWeight.w700, size: 10.w),
        ]));
}

// BOTTOM SHEET
void customBottomSheet(BuildContext context, String title, Widget child,
    {Color? backgroundColor}) {
  final borderRadius = BorderRadius.vertical(top: Radius.circular(25.r));

  showModalBottomSheet(
      context: context,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => CustomContainer(
          color: backgroundColor ?? Colors.white,
          borderRadius: borderRadius,
          padding: EdgeInsets.all(16.w),
          shadowColor: Colors.black.withAlpha(25),
          offset: Offset(0, -4),
          blurRadius: 10.0,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            CustomText(text: title.toUpperCase(), weight: FontWeight.w600),
            Divider(color: Colors.grey.shade100),
            child
          ])));
}

// CUSTOM DIALOG
void customDialog(BuildContext context,
    {String? icon,
    MaterialColor? iconColor,
    String? title,
    String? subTitle,
    String? buttonText,
    void Function()? onPressed,
    String? buttonText2,
    void Function()? onPressed2}) {
  final child = Column(mainAxisSize: MainAxisSize.min, children: [
    CustomContainer(
        padding: EdgeInsets.all(12.w),
        color: iconColor?.shade100 ?? AppColor.blue_14,
        borderRadius: BorderRadius.circular(12.r),
        child: CustomImage(
            imageType: ImageType.SVG_LOCAL,
            color: iconColor?.shade700 ?? AppColor.blue_3,
            height: 28.w,
            width: 28.w,
            imageUrl: icon ?? AppSvgs.CHECK)),
    SizedBox(height: 16.w),
    if (title != null)
      CustomText(text: title, size: 16.w, weight: FontWeight.w600),
    if (subTitle != null)
      CustomText(
          text: subTitle,
          align: TextAlign.center,
          color: Colors.grey.shade700,
          size: 10.w),
    SizedBox(height: 16.w),
    Row(children: [
      Expanded(
          child: CustomButton(
              onPressed: onPressed ?? () => context.pop(),
              backgroundColor: AppColor.blue_1,
              height: 40.w,
              child: CustomText(
                  text: buttonText ?? "Ok",
                  color: Colors.white,
                  weight: FontWeight.w600))),
      if (onPressed2 != null) ...[
        SizedBox(width: 8.w),
        Expanded(
            child: CustomButton(
                onPressed: onPressed2,
                backgroundColor: AppColor.blue_1,
                height: 40.w,
                child: CustomText(
                    text: buttonText2 ?? "Ok",
                    color: Colors.white,
                    weight: FontWeight.w600))),
      ]
    ])
  ]);

  showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(40),
      builder: (context) => Dialog(child: child.paddingAll(16.w)));
}
