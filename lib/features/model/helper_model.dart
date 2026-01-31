import '../../app.dart';

class SummaryModel {
  final num value;
  final String name;
  final MaterialColor color;

  SummaryModel({required this.value, required this.name, required this.color});
}

// Helper class for monthly summary parameters
class MonthYearUserId {
  final int year;
  final int month;

  MonthYearUserId({
    required this.year,
    required this.month,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthYearUserId &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}

// Statistics model
class LeaveStatistics {
  final int pendingCount;
  final int approvedCount;
  final int rejectedCount;
  final double totalLeaveTaken;
  final LeaveBalanceModel? leaveBalance;

  LeaveStatistics({
    required this.pendingCount,
    required this.approvedCount,
    required this.rejectedCount,
    required this.totalLeaveTaken,
    this.leaveBalance,
  });
}

class TransactionModel {
  List<ChipModel>? chip;
  List<List<String>>? dates;
  String? icon;
  String? bottomText;

  TransactionModel({this.chip, this.dates, this.icon, this.bottomText});
}

class ChipModel {
  String? title;
  MaterialColor? color;

  ChipModel({this.title, this.color});
}
