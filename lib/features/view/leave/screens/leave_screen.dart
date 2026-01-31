import 'package:intl/intl.dart';

import '../../../../app.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveTransaction = ref.watch(leaveTransactionProvider);

    return Scaffold(
        appBar: customAppBar(context, title: "Leave"),
        body: leaveTransaction.when(
            data: (transaction) {
              return ListView.builder(
                  itemCount: 1 + transaction.length,
                  padding: EdgeInsets.only(top: 16.w),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    if (index == 0) return leaveSummary();
                    return _currLeaveTransaction(transaction[index - 1]);
                  });
            },
            error: (_, __) => leaveSummary().paddingFromLTRB(top: 16.w),
            loading: () => AlertScreen(type: ScreenType.LOADING)),
        floatingActionButton: FloatingActionButton(
            onPressed: () => context.push("/leave_request"),
            backgroundColor: AppColor.blue_1,
            child: IgnorePointer(
                child: CustomImage(
                    imageType: ImageType.SVG_LOCAL,
                    imageUrl: AppSvgs.ADD,
                    color: Colors.white70))));
  }

  Widget _currLeaveTransaction(LeaveModel leave) {
    final appliedDate = DateFormat("EEE dd MMM").format(leave.appliedDate);
    final format = DateFormat("dd MMM yyyy");
    final startDate = format.format(leave.startDate);
    final endDate = format.format(leave.endDate);

    final transaction = TransactionModel(chip: [
      ChipModel(title: appliedDate),
      ChipModel(),
      ChipModel(title: leave.leaveType.value, color: Colors.green),
      ChipModel(title: leave.status.value, color: Colors.orange)
    ], dates: [
      ["Start date", startDate],
      [],
      ["End date", endDate],
      [],
      ["Total days", leave.numberOfDays.toStringAsFixed(1)]
    ], icon: AppSvgs.CHECK, bottomText: leave.reason);

    return buildTransaction(transaction);
  }
}
