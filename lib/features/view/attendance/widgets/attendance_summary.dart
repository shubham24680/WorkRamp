import '../../../../app.dart';

Widget attendanceSummary({bool isHome = false}) {
  return Consumer(builder: (context, ref, child) {
    final now = DateTime.now();
    final filter = MonthYearUserId(year: now.year, month: now.month);
    final monthlyAttendance =
        ref.watch(monthlyAttendanceSummaryProvider(filter));

    return monthlyAttendance.when(
        data: (attendance) {
          final totalAttendance = [
            SummaryModel(
                value: attendance.presentDays,
                name: AttendanceStatus.present.value,
                color: Colors.green),
            SummaryModel(
                value: attendance.absentDays,
                name: AttendanceStatus.absent.value,
                color: Colors.red),
            SummaryModel(
                value: attendance.halfDays,
                name: AttendanceStatus.halfDay.value,
                color: Colors.orange),
          ];

          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isHome)
                  buildTitle("Attendance",
                      subtitle: "(Days)",
                      event: () => context.push("/attendance")),
                buildSummary(totalAttendance),
              ]);
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  });
}
