import 'dart:developer';

import '../../app.dart';

// Attendance History Provider
final attendanceHistoryProvider =
    FutureProvider.family<List<AttendanceModel>, String>((ref, userId) async {
  final service = ref.watch(attendanceServiceProvider);
  return await service.getAttendanceHistory(userId: userId);
});

// Monthly Attendance Summary Provider
final monthlyAttendanceSummaryProvider =
    FutureProvider.family<AttendanceSummary, MonthYearUserId>(
        (ref, params) async {
  final service = ref.watch(attendanceServiceProvider);
  final userId = ref.watch(profileProvider).value?.userId;
  if (userId == null) throw Exception;

  log("Monthly Attendance Summary Provider - $userId");
  return await service.getMonthlyAttendanceSummary(
    userId: userId,
    year: params.year,
    month: params.month,
  );
});

class TotalAttendanceState {
  final DateTime time;

  TotalAttendanceState({required this.time});

  factory TotalAttendanceState.initial() =>
      TotalAttendanceState(time: DateTime.now());

  TotalAttendanceState copyWith({DateTime? time}) {
    return TotalAttendanceState(time: time ?? this.time);
  }
}

class TotalAttendanceNotifier extends StateNotifier<TotalAttendanceState> {
  TotalAttendanceNotifier() : super(TotalAttendanceState.initial());

  void updateTime(DateTime time) => state = state.copyWith(time: time);
}

final totalAttendanceProvider =
    StateNotifierProvider<TotalAttendanceNotifier, TotalAttendanceState>(
        (ref) => TotalAttendanceNotifier());
