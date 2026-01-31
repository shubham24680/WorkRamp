import 'package:intl/intl.dart';

import '../../app.dart';

final leaveStatisticsProvider = FutureProvider<LeaveStatistics>((ref) {
  final userId = ref.watch(profileProvider).value?.userId;

  if (userId == null) throw Exception();
  return LeaveService().getLeaveStatistics(userId);
});

final leaveTransactionProvider = FutureProvider<List<LeaveModel>>((ref) {
  final userId = ref.watch(profileProvider).value?.userId;

  if (userId == null) throw Exception();
  return LeaveService().getUserLeaves(userId);
});

final leaveBalanceProvider = FutureProvider<LeaveBalanceModel>((ref) {
  final userId = ref.watch(profileProvider).value?.userId;

  if (userId == null) throw Exception();
  return LeaveService().getLeaveBalance(userId);
});

class LeaveRequestState {
  final LeaveType leaveType;
  final TextEditingController fromDate;
  final TextEditingController toDate;
  final TextEditingController reason;
  final bool halfDay;
  final double totalWorkingDays;
  final String? fromErrorText;
  final String? toErrorText;
  final String? reasonErrorText;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  LeaveRequestState(
      {required this.leaveType,
      required this.fromDate,
      required this.toDate,
      required this.reason,
      required this.halfDay,
      this.totalWorkingDays = 0.0,
      this.fromErrorText,
      this.toErrorText,
      this.reasonErrorText,
      required this.isLoading,
      required this.isSuccess,
      this.errorMessage});

  factory LeaveRequestState.initial() => LeaveRequestState(
      leaveType: LeaveType.casual,
      fromDate: TextEditingController(),
      toDate: TextEditingController(),
      reason: TextEditingController(),
      halfDay: false,
      isLoading: false,
      isSuccess: false);

  LeaveRequestState copyWith(
          {LeaveType? leaveType,
          bool? halfDay,
          DateTime? startDate,
          DateTime? endDate,
          double? totalWorkingDays,
          String? fromErrorText,
          String? toErrorText,
          String? reasonErrorText,
          bool? isLoading,
          bool? isSuccess,
          String? errorMessage}) =>
      LeaveRequestState(
          leaveType: leaveType ?? this.leaveType,
          reason: reason,
          fromDate: fromDate,
          toDate: toDate,
          halfDay: halfDay ?? this.halfDay,
          totalWorkingDays: totalWorkingDays ?? this.totalWorkingDays,
          fromErrorText: fromErrorText,
          toErrorText: toErrorText,
          reasonErrorText: reasonErrorText,
          isLoading: isLoading ?? this.isLoading,
          isSuccess: isSuccess ?? this.isSuccess,
          errorMessage: errorMessage);
}

class LeaveRequestNotifier extends StateNotifier<LeaveRequestState> {
  LeaveRequestNotifier() : super(LeaveRequestState.initial());

  void chooseLeave(String? type) {
    if (type == null) return;

    state = state.copyWith(
        leaveType:
            LeaveType.values.firstWhere((element) => element.value == type));
  }

  void checkHalfDay(bool value) {
    state = state.copyWith(halfDay: value);
    calculateWorkingDays();
  }

  void calculateWorkingDays() {
    final startDate = state.fromDate.text;
    final endDate = state.toDate.text;
    if (startDate.isEmpty || endDate.isEmpty) return;
    final dateFormat = DateFormat('yyyy-MM-dd');
    final total = dateFormat
            .parse(endDate)
            .difference(dateFormat.parse(startDate))
            .inDays +
        (state.halfDay ? 0.5 : 1.0);

    state = state.copyWith(totalWorkingDays: total);
  }

  Future<void> apply(WidgetRef ref) async {
    state = state.copyWith(isLoading: true);
    final from = state.fromDate.text.isEmpty ? "Please Select date" : null;
    final to = state.toDate.text.isEmpty ? "Please Select date" : null;
    final reason = state.reason.text.isEmpty ? "Please enter reason" : null;
    final userId = ref.watch(profileProvider).value?.userId;

    if (from == null && to == null && reason == null && userId != null) {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final startDate = dateFormat.parse(state.fromDate.text);
      final endDate = dateFormat.parse(state.toDate.text);

      // Check if user has sufficient leave balance
      try {
        final canApply = await LeaveService().canApplyLeave(
          userId: userId,
          leaveType: state.leaveType,
          startDate: startDate,
          endDate: endDate,
          numberOfDays: state.totalWorkingDays,
        );

        if (!canApply) {
          state = state.copyWith(
              isLoading: false,
              errorMessage:
                  'Insufficient leave balance for ${state.leaveType.value} leave');
        } else {
          // Apply leave
          await LeaveService().applyLeave(
            userId: userId,
            leaveType: state.leaveType,
            startDate: startDate,
            endDate: endDate,
            reason: state.reason.text,
            isHalfDay: state.halfDay,
          );
          state = state.copyWith(isSuccess: true, isLoading: false);
          releaseResources();
          ref.invalidate(leaveStatisticsProvider);
          ref.invalidate(leaveBalanceProvider);
          ref.invalidate(leaveTransactionProvider);
        }
      } catch (e) {
        state = state.copyWith(
            isLoading: false,
            errorMessage: e.toString().replaceAll('Exception: ', ''));
      }
    } else {
      state = state.copyWith(
          fromErrorText: from,
          toErrorText: to,
          reasonErrorText: reason,
          isLoading: false);
    }
  }

  void releaseResources() {
    state = state.copyWith(leaveType: LeaveType.casual, isSuccess: false);
    state.fromDate.clear();
    state.toDate.clear();
    state.reason.clear();
  }
}

final leaveRequestProvider =
    StateNotifierProvider.autoDispose<LeaveRequestNotifier, LeaveRequestState>(
        (ref) => LeaveRequestNotifier());
