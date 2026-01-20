import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';
import '../../../../app.dart';

class CheckInOrOutScreen extends ConsumerWidget {
  const CheckInOrOutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider).value!;
    final todayAttendanceAsync = ref.watch(todayAttendanceProvider);
    final checkInTime = todayAttendanceAsync.value?.checkInTime;

    return Scaffold(
      appBar: customAppBar(context, title: "Attendance"),
      body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // Work Type Selection (for check-in)
            if (user.canCheckInAnywhere && checkInTime == null)
              _buildWorkTypeSelection(ref),

            _buildWorkingHr(todayAttendanceAsync),

            // Office Location Info
            _buildOfficeLocation(user, ref),
          ])),
      bottomNavigationBar: todayAttendanceAsync.when(
        data: (attendance) {
          if (attendance == null || attendance.checkInTime == null) {
            // Not checked in yet
            return _buildCheckButton(
                ref,
                () => _handleCheckIn(ref, user, context),
                Colors.green.shade700,
                AppSvgs.CHECK_IN,
                'Check In',
                'Tap to mark your attendance');
          } else if (attendance.checkOutTime == null) {
            // Checked in, not checked out
            return _buildCheckButton(
                ref,
                () => _handleCheckOut(ref, attendance, user, context),
                Colors.red.shade700,
                AppSvgs.CHECK_OUT,
                'Check Out',
                'Tap to end your shift');
          }

          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
        error: (error, _) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return CustomText(
            text: title,
            size: 10.w,
            weight: FontWeight.w600,
            color: Colors.grey.shade700)
        .paddingFromLTRB(bottom: 8.w);
  }

  Widget _buildWorkTypeButton(WidgetRef ref, WorkType selectedWorkType) {
    final workType = ref.watch(attendanceNotifierProvider).workType;
    final attendanceNotifier = ref.watch(attendanceNotifierProvider.notifier);
    final isSelected = (workType == selectedWorkType);

    return CustomContainer(
        event: () => attendanceNotifier.setWorkType(selectedWorkType),
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(vertical: 8.w),
        color: isSelected ? AppColor.blue_14 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6.r),
        child: CustomText(
            text: selectedWorkType.value,
            align: TextAlign.center,
            size: 10.w,
            maxLines: 1,
            color: isSelected ? AppColor.blue_3 : Colors.grey.shade700,
            weight: FontWeight.bold));
  }

  Widget _buildWorkTypeSelection(WidgetRef ref) {
    return CustomContainer(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 16.w),
        padding: EdgeInsets.all(16.w),
        borderRadius: BorderRadius.circular(25.r),
        shadowColor: Colors.black.withAlpha(25),
        blurRadius: 10.0,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildTitle("Work Type"),
          Row(children: WorkType.values.map((w) => Expanded(
              child: _buildWorkTypeButton(ref, w))).toList()
          // [
          //   Expanded(
          //       child: _buildWorkTypeButton(ref, WorkType.office)),
          //   SizedBox(width: 4.w),
          //   Expanded(
          //       child: _buildWorkTypeButton(
          //           ref, WorkType.workFromHome))
          // ]
          )
        ]));
  }

  Widget _buildLocationAddress(
      String icon, String locationName, String address) {
    return Row(children: [
      CustomContainer(
          padding: EdgeInsets.all(12.w),
          color: AppColor.blue_14,
          borderRadius: BorderRadius.circular(12.r),
          child: CustomImage(
              imageType: ImageType.SVG_LOCAL,
              color: AppColor.blue_3,
              height: 28.w,
              width: 28.w,
              imageUrl: icon)),
      SizedBox(width: 16.w),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        CustomText(text: locationName, size: 16.w, weight: FontWeight.bold),
        SizedBox(height: 2.w),
        CustomText(text: address, color: Colors.grey.shade700, size: 10.w)
      ]))
    ]);
  }

  Widget _buildWorkingHr(AsyncValue<AttendanceModel?> todayAttendanceAsync) {
    return todayAttendanceAsync.when(
        data: (attendance) {
          final checkInTime = attendance?.checkInTime;
          if (attendance == null || checkInTime == null) {
            return const SizedBox.shrink();
          }

          final checkIn = formatWorkHours(checkInTime);
          final checkOut = attendance.checkOutTime;
          final duration = formatWorkHours(attendance.totalHours ??
              (DateTime.now().difference(checkInTime)).inMinutes);
          final overtime = attendance.overtimeHours;

          return CustomContainer(
              color: Colors.white,
              margin: EdgeInsets.only(bottom: 16.w),
              padding: EdgeInsets.all(16.w),
              borderRadius: BorderRadius.circular(25.r),
              shadowColor: Colors.black.withAlpha(25),
              blurRadius: 10.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTitle("Attendance status"),
                          if (overtime != null)
                            CustomChip(
                                label: "Overtime: ${formatWorkHours(0)}",
                                backgroundColor: Colors.orange.shade100,
                                textColor: Colors.orange.shade700)
                        ]),
                    _buildLocationAddress(
                        AppSvgs.CLOCK,
                        duration,
                        checkOut != null
                            ? "$checkIn - ${formatWorkHours(checkOut)}"
                            : "Check In at $checkIn")
                  ]));
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }

  Widget _buildOfficeLocation(UserModel user, WidgetRef ref) {
    final workType = ref.watch(attendanceNotifierProvider).workType;
    final officeLocationAsync = ref.watch(locationProvider);
    final todayAttendance = ref.watch(todayAttendanceProvider).value;
    String? inAddress = todayAttendance?.checkInAddress;
    String? outAddress = todayAttendance?.checkOutAddress;
    DateTime? inTime = todayAttendance?.checkInTime;
    DateTime? outTime = todayAttendance?.checkOutTime;

    return officeLocationAsync.when(
      data: (location) {
        return CustomContainer(
            color: Colors.white,
            margin: EdgeInsets.only(bottom: 16.w),
            padding: EdgeInsets.all(16.w),
            borderRadius: BorderRadius.circular(25.r),
            shadowColor: Colors.black.withAlpha(25),
            blurRadius: 10.0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CustomText(
                    text: 'Assigned Office',
                    size: 10.w,
                    weight: FontWeight.w600,
                    color: Colors.grey.shade700),
                CustomChip(
                    label: workType.value,
                    backgroundColor: Colors.green.shade100,
                    textColor: Colors.green.shade700)
              ]),
              SizedBox(height: 8.w),
              _buildLocationAddress(
                  AppSvgs.OFFICE, location.locationName, location.address),
              if (inAddress != null || outAddress != null) ...[
                Divider(color: Colors.grey.shade100),
                CustomText(
                    text: 'Current Location',
                    size: 10.w,
                    weight: FontWeight.w600,
                    color: Colors.grey.shade700),
              ],
              if (inAddress != null && inTime != null) ...[
                SizedBox(height: 8.w),
                _buildLocationAddress(AppSvgs.START_LOCATION,
                    "Check In - ${formatWorkHours(inTime)}", inAddress),
              ],
              if (outAddress != null && outTime != null) ...[
                SizedBox(height: 8.w),
                _buildLocationAddress(AppSvgs.LOCATION,
                    "Check Out - ${formatWorkHours(outTime)}", outAddress)
              ]
            ]));
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Future<void> _handleCheckIn(
      WidgetRef ref, UserModel user, BuildContext context) async {
    await ref.read(attendanceNotifierProvider.notifier).checkIn(user: user);
    listenInOrOut(ref, context);
  }

  Future<void> _handleCheckOut(WidgetRef ref, AttendanceModel attendance,
      UserModel user, BuildContext context) async {
    await ref.read(attendanceNotifierProvider.notifier).checkOut(
          user: user,
          todayAttendance: attendance,
        );
    listenInOrOut(ref, context);
  }

  void listenInOrOut(WidgetRef ref, BuildContext context) {
    if (context.mounted) {
      final attendanceState = ref.read(attendanceNotifierProvider);

      if (attendanceState.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(text: attendanceState.successMessage ?? ""),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh today's attendance
        ref.invalidate(todayAttendanceProvider);
        ref.invalidate(monthlyAttendanceSummaryProvider);
      } else if (attendanceState.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(text: attendanceState.errorMessage ?? ""),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCheckButton(WidgetRef ref, void Function()? onPressed,
      Color backgroundColor, String icon, String label, String hint) {
    final attendanceState = ref.watch(attendanceNotifierProvider);

    return Column(mainAxisSize: MainAxisSize.min, children: [
      CustomButton(
          onPressed: attendanceState.isLoading ? null : onPressed,
          height: 50.w,
          backgroundColor: backgroundColor,
          child: attendanceState.isLoading
              ? CircularProgressIndicator(
                  color: backgroundColor, strokeCap: StrokeCap.round)
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  CustomImage(
                      imageType: ImageType.SVG_LOCAL,
                      imageUrl: icon,
                      height: 24.w,
                      color: Colors.white),
                  SizedBox(width: 8.w),
                  CustomText(
                      text: label,
                      color: Colors.white,
                      size: 20.w,
                      weight: FontWeight.w600)
                ])),
      SizedBox(height: 4.w),
      CustomText(text: hint, color: Colors.grey.shade700, size: 8.w)
    ]).paddingSymmetric(horizontal: 16.w, vertical: 16.w);
  }
}
