import '../../../../app.dart';

class TotalAttendance extends ConsumerWidget {
  const TotalAttendance({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final filter = MonthYearUserId(year: now.year, month: now.month);
    final monthlyAttendance =
        ref.watch(monthlyAttendanceSummaryProvider(filter));

    return monthlyAttendance.when(
        data: (attendance) {
          final totalAttendance = [
            TotalAttendanceModel(
                value: attendance.presentDays,
                name: "Present",
                color: Colors.green),
            TotalAttendanceModel(
                value: attendance.absentDays,
                name: "Absent",
                color: Colors.red),
            TotalAttendanceModel(
                value: attendance.halfDays, name: "Half", color: Colors.orange),
            TotalAttendanceModel(value: 0, name: "Late", color: Colors.blue),
            TotalAttendanceModel(
                value: 13, name: "Leave", color: Colors.purple),
          ];

          return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTitle("Total Attendance", subtitle: "(Days)"),
                CustomContainer(
                    color: Colors.white,
                    margin:
                        EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
                    padding: EdgeInsets.symmetric(vertical: 4.w),
                    borderRadius: BorderRadius.circular(25.r),
                    shadowColor: Colors.black.withAlpha(25),
                    blurRadius: 10.0,
                    child: GridView.builder(
                        itemCount: totalAttendance.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.w,
                            childAspectRatio: 1.25),
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomContainer(
                                  color: totalAttendance[index].color.shade100,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.w, horizontal: 8.w),
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: CustomText(
                                      text: totalAttendance[index]
                                          .value
                                          .toString()
                                          .padLeft(2, "0"),
                                      color:
                                          totalAttendance[index].color.shade700,
                                      weight: FontWeight.w600,
                                      size: 16.w)),
                              SizedBox(height: 4.w),
                              CustomText(text: totalAttendance[index].name)
                            ],
                          );
                        }))
              ]);
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  }
}
