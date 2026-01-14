import 'package:intl/intl.dart';
import '../../../../app.dart';

class AttendanceAppBar extends ConsumerWidget {
  const AttendanceAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = ScreenUtil().statusBarHeight + 90.w + 190.w;
    return SizedBox(
        height: height,
        child: Stack(alignment: Alignment.bottomCenter, children: [
          _buildTopWidget(context, ref),
          _buildAvgWorkDuration(ref),
          _buildCheckout(context, ref)
        ]));
  }

  Widget _buildTopWidget(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final String now = DateFormat("dd MMM, yyyy").format(DateTime.now());
    final topPadding = ScreenUtil().statusBarHeight + 8.w;

    return CustomContainer(
        color: AppColor.blue_1,
        margin: EdgeInsets.only(bottom: 110.w),
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: topPadding),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r)),
        child: Column(children: [
          Row(children: [
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
          ]),
          SizedBox(height: 12.w),
          Row(children: [
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
          ])
        ]));
  }

  Widget _buildAvgWorkDuration(WidgetRef ref) {
    final address = ref.watch(locationProvider).value?.address;
    final now = DateTime.now();
    final user = MonthYearUserId(year: now.year, month: now.month);
    final avgWorkHr = ref
        .watch(monthlyAttendanceSummaryProvider(user))
        .value
        ?.averageWorkHours;
    final times = formatWorkHours(avgWorkHr ?? 0, clockFormat: true).split(" ");

    return CustomContainer(
      color: AppColor.white,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 30.w),
      padding: EdgeInsets.only(top: 16.w, bottom: 30.w),
      borderRadius: BorderRadius.circular(25.r),
      offset: Offset(0, 8),
      shadowColor: Colors.black.withAlpha(25),
      blurRadius: 10.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: "Average Work Duration", weight: FontWeight.w500),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildTime(times)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                  imageType: ImageType.SVG_LOCAL,
                  imageUrl: AppSvgs.LOCATION,
                  height: 12.w),
              SizedBox(width: 4.w),
              if (address != null)
                Flexible(
                    child: CustomText(
                        text: address,
                        size: 10.w,
                        overflow: TextOverflow.ellipsis))
            ],
          ).paddingSymmetric(horizontal: 16.w)
        ],
      ),
    );
  }

  List<Widget> _buildTime(List<String> times) {
    return List.generate(times.length, (index) {
      if (index % 2 == 0) {
        return CustomContainer(
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.all(8.w),
          color: Colors.grey.withAlpha(100),
          borderRadius: BorderRadius.circular(12.r),
          child: CustomText(
              text: times[index].padLeft(2, "0"),
              size: 32.w,
              weight: FontWeight.w600),
        );
      }
      return CustomText(text: times[index], size: 32.w);
    });
  }

  Widget _buildCheckout(BuildContext context, WidgetRef ref) {
    final todayAttendanceAsync = ref.watch(todayAttendanceProvider);

    return todayAttendanceAsync.when(
        data: (attendance) {
          final checkIn = attendance?.checkInTime;
          final checkOut = attendance?.checkOutTime;
          Color backgroundColor;
          String text;

          if (checkIn == null) {
            backgroundColor = Colors.green.shade700;
            text = "Check In";
          } else if (checkOut == null) {
            backgroundColor = Colors.red.shade700;
            text = "Check Out";
          } else {
            backgroundColor = AppColor.blue_1;
            text = "Attendance Marked";
          }

          return CustomButton(
                  buttonNature: ButtonNature.BOUNDED,
                  backgroundColor: backgroundColor,
                  borderRadius: 12.r,
                  height: 50.w,
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CustomImage(
                        imageType: ImageType.SVG_LOCAL,
                        imageUrl: AppSvgs.CLOCK,
                        color: AppColor.white,
                        height: 16.w),
                    SizedBox(width: 8.w),
                    CustomText(
                        text: text,
                        color: AppColor.white,
                        weight: FontWeight.w600)
                  ]),
                  onPressed: () => context.push("/check_in_or_out"))
              .paddingFromLTRB(bottom: 10);
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}
