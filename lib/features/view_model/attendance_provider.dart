// Attendance Service Provider
import 'dart:developer';

import '../../app.dart';

final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService();
});

// Office Location Service Provider
final officeLocationServiceProvider = Provider<OfficeLocationService>((ref) {
  return OfficeLocationService();
});

// Today's Attendance Provider
final todayAttendanceProvider = FutureProvider<AttendanceModel?>((ref) async {
  final userId = ref.watch(profileProvider).value?.userId;

  log("ATTENDANCE USER ID - $userId");
  if (userId == null) throw Exception;

  final service = ref.watch(attendanceServiceProvider);
  return await service.getTodayAttendance(userId);
});

// User's Assigned Office Location Provider
final userOfficeLocationProvider =
    FutureProvider.family<OfficeLocation?, String>((ref, locationId) async {
  final service = ref.watch(officeLocationServiceProvider);
  return await service.getOfficeLocationById(locationId);
});

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
  return await service.getMonthlyAttendanceSummary(
    userId: params.userId,
    year: params.year,
    month: params.month,
  );
});

// Helper class for monthly summary parameters
class MonthYearUserId {
  final String userId;
  final int year;
  final int month;

  MonthYearUserId({
    required this.userId,
    required this.year,
    required this.month,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthYearUserId &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          year == other.year &&
          month == other.month;

  @override
  int get hashCode => userId.hashCode ^ year.hashCode ^ month.hashCode;
}

// Attendance State Notifier
class AttendanceState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final AttendanceModel? currentAttendance;

  AttendanceState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.currentAttendance,
  });

  AttendanceState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    AttendanceModel? currentAttendance,
  }) {
    return AttendanceState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successMessage: successMessage,
      currentAttendance: currentAttendance ?? this.currentAttendance,
    );
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceService _attendanceService;
  final OfficeLocationService _officeLocationService;

  AttendanceNotifier(this._attendanceService, this._officeLocationService)
      : super(AttendanceState());

  Future<void> checkIn({
    required UserModel user,
    WorkType workType = WorkType.office,
  }) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    try {
      final officeLocation = await _officeLocationService
          .getOfficeLocationById(user.officeLocationId);

      if (officeLocation == null) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'Office location not found');
        return;
      }

      // Perform check-in
      final result = await _attendanceService.checkIn(
        user: user,
        officeLocation: officeLocation,
        workType: workType,
      );

      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          successMessage: result.message,
          currentAttendance: result.attendance,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to check in: ${e.toString()}',
      );
    }
  }

  Future<void> checkOut({
    required UserModel user,
    required AttendanceModel todayAttendance,
  }) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    try {
      final result = await _attendanceService.checkOut(
        user: user,
        todayAttendance: todayAttendance,
      );

      if (result.success) {
        state = state.copyWith(
          isLoading: false,
          successMessage: result.message,
          currentAttendance: result.attendance,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: result.message,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to check out: ${e.toString()}',
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(
      errorMessage: null,
      successMessage: null,
    );
  }
}

final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final attendanceService = ref.watch(attendanceServiceProvider);
  final officeLocationService = ref.watch(officeLocationServiceProvider);
  return AttendanceNotifier(attendanceService, officeLocationService);
});
