import 'package:intl/intl.dart';

import '../../../../app.dart';

class AttendanceAppBar extends ConsumerWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final topPadding = ScreenUtil().statusBarHeight + 8.w;
    final String now = DateFormat("dd MMM, yyyy").format(DateTime.now());

    return CustomContainer(
        color: AppColor.blue_1,
        margin: EdgeInsets.only(bottom: 100.w),
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: topPadding),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r)),
        child: Column(
          children: [
            Row(
              children: [
                CustomImage(
                  imageType: ImageType.SVG_LOCAL,
                  imageUrl: AppSvgs.AVATAR,
                  height: 36.w,
                  width: 36.w,
                  borderRadius: BorderRadius.circular(1.sw),
                  onClick: () => context.push("/profile"),
                ),
                SizedBox(width: 8.w),
                profileState.when(
                    data: (userData) => Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              CustomText(
                                  text: userData.name,
                                  color: AppColor.white,
                                  weight: FontWeight.w700,
                                  overflow: TextOverflow.ellipsis),
                              CustomText(
                                  text: userData.designation,
                                  color: AppColor.white,
                                  size: 12.w,
                                  overflow: TextOverflow.ellipsis)
                            ])),
                    error: (_, __) => const SizedBox.shrink(),
                    loading: () => const SizedBox.shrink()),
                SizedBox(width: 8.w),
                CustomButton(
                    buttonType: ButtonType.ICON,
                    icon: AppSvgs.SEARCH,
                    onPressed: () => context.push("/search"))
              ],
            ),
            SizedBox(height: 12.w),
            Row(
              children: [
                CustomText(
                    text: "Todays Attendance",
                    color: AppColor.white,
                    weight: FontWeight.bold,
                    size: 16.w,
                    overflow: TextOverflow.ellipsis),
                const Spacer(),
                CustomText(
                    text: now,
                    color: AppColor.white,
                    size: 12.w,
                    overflow: TextOverflow.ellipsis)
              ],
            )
          ],
        ));
  }
}
