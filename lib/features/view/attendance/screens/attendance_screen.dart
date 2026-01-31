import 'package:intl/intl.dart';

import '../../../../app.dart';

class TotalAttendanceScreen extends ConsumerWidget {
  const TotalAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final filter = MonthYearUserId(year: now.year, month: now.month);
    final monthlyAttendance =
        ref.watch(monthlyAttendanceSummaryProvider(filter));

    return Scaffold(
        appBar: customAppBar(context, title: "Attendance"),
        body: monthlyAttendance.when(
            data: (attendance) {
              return ListView.builder(
                  itemCount: 1 + attendance.attendances.length,
                  padding: EdgeInsets.only(top: 16.w, bottom: 32.w),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 0) return attendanceSummary();
                    final todayAttendance = attendance.attendances[index - 1];
                    return (todayAttendance.status == AttendanceStatus.weekend)
                        ? _weekend(todayAttendance)
                        : _currDayAttendance(todayAttendance);
                  });
            },
            error: (_, __) => attendanceSummary().paddingFromLTRB(top: 16.w),
            loading: () => AlertScreen(type: ScreenType.LOADING)),
        floatingActionButton: FloatingActionButton(
            onPressed: () => context.push("/attendance_request"),
            backgroundColor: AppColor.blue_1,
            child: IgnorePointer(
                child: CustomImage(
                    imageType: ImageType.SVG_LOCAL,
                    imageUrl: AppSvgs.ADD,
                    color: Colors.white70))));
  }

  Widget _weekend(AttendanceModel todayAttendance) {
    final dateFormat = DateFormat("EEE dd MMM");
    final date = todayAttendance.date;
    final firstDate = dateFormat.format(date);
    // final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    // final nextDay = (lastDayOfMonth.compareTo(date) == 0)
    //     ? null
    //     : dateFormat.format(date.add(Duration(days: 1)));
    final color = Colors.red;

    return CustomContainer(
      color: color.shade100,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 8.w),
      padding: EdgeInsets.all(16.w),
      borderRadius: BorderRadius.circular(18.r),
      child: CustomText(
          text: "Weekend: $firstDate",
          color: color.shade700,
          weight: FontWeight.w600,
          align: TextAlign.center),
    );
  }

  Widget _currDayAttendance(AttendanceModel todayAttendance) {
    final today = DateFormat("EEE dd MMM").format(todayAttendance.date);
    final inTime = todayAttendance.checkInTime;
    final outTime = todayAttendance.checkOutTime;
    final totalWorkingHr = todayAttendance.totalHours;
    final inAddress = todayAttendance.checkInAddress;
    final transaction = TransactionModel(chip: [
      ChipModel(title: today),
      ChipModel(),
      ChipModel(title: todayAttendance.workType.value, color: Colors.green),
      ChipModel(title: todayAttendance.status.value, color: Colors.orange)
    ], dates: [
      ["Check in", (inTime != null) ? formatWorkHours(inTime) : "-"],
      [],
      ["Check out", (outTime != null) ? formatWorkHours(outTime) : "-"],
      [],
      [
        "Total hours",
        (totalWorkingHr != null)
            ? formatWorkHours(totalWorkingHr, clockFormat: true)
                .replaceAll(" ", "")
            : "-"
      ]
    ], icon: AppSvgs.LOCATION, bottomText: inAddress);

    return buildTransaction(transaction);
  }
}
