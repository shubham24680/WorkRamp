import '../../../../app.dart';

Widget leaveSummary({bool isHome = false}) {
  return Consumer(builder: (context, ref, child) {
    if (isHome) {
      final leaveStatistics = ref.watch(leaveStatisticsProvider);
      return leaveStatistics.when(
          data: (leaves) {
            final totalLeave = [
              SummaryModel(
                  value: leaves.approvedCount,
                  name: LeaveStatus.approved.value,
                  color: Colors.green),
              SummaryModel(
                  value: leaves.rejectedCount,
                  name: LeaveStatus.rejected.value,
                  color: Colors.red),
              SummaryModel(
                  value: leaves.pendingCount,
                  name: LeaveStatus.pending.value,
                  color: Colors.orange),
              SummaryModel(
                  value: leaves.totalLeaveTaken,
                  name: "Taken",
                  color: Colors.purple),
              SummaryModel(
                  value: leaves.leaveBalance?.totalLeaveRemaining ?? 0,
                  name: "Remaining",
                  color: Colors.brown),
            ];

            return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTitle("Leave",
                      subtitle: "(Days)", event: () => context.push("/leave")),
                  buildSummary(totalLeave),
                ]);
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink());
    }

    final leaveBalance = ref.watch(leaveBalanceProvider);
    return leaveBalance.when(
        data: (balance) {
          final totalBalance = [
            SummaryModel(
                value: balance.casualLeave, name: "Casual", color: Colors.blue),
            SummaryModel(
                value: balance.sickLeave, name: "Sick", color: Colors.blue),
            SummaryModel(
                value: balance.annualLeave, name: "Annual", color: Colors.blue),
            SummaryModel(
                value: balance.unpaidLeave, name: "Unpaid", color: Colors.blue),
            SummaryModel(
                value: balance.casualLeaveUsed,
                name: "Casual Used",
                color: Colors.blue),
            SummaryModel(
                value: balance.sickLeaveUsed,
                name: "Sick Used",
                color: Colors.blue),
            SummaryModel(
                value: balance.annualLeaveUsed,
                name: "Annual Used",
                color: Colors.blue),
            SummaryModel(
                value: balance.unpaidLeaveUsed,
                name: "Unpaid Used",
                color: Colors.blue),
          ];

          return buildSummary(totalBalance);
        },
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const SizedBox.shrink());
  });
}
