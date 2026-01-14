// Attendance Service Provider
import 'dart:developer';

import '../../app.dart';

final attendanceServiceProvider = Provider<AttendanceService>((ref) {
  return AttendanceService();
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
  return await OfficeLocationService().getOfficeLocation(locationId);
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
  final userId = ref.watch(profileProvider).value?.userId;
  if (userId == null) throw Exception;

  log("Monthly Attendance Summary Provider - $userId");
  return await service.getMonthlyAttendanceSummary(
    userId: userId,
    year: params.year,
    month: params.month,
  );
});

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

// Attendance State Notifier
class AttendanceState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final AttendanceModel? currentAttendance;
  final WorkType workType;

  AttendanceState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.currentAttendance,
    this.workType = WorkType.office,
  });

  AttendanceState copyWith(
      {bool? isLoading,
      String? errorMessage,
      String? successMessage,
      AttendanceModel? currentAttendance,
      WorkType? workType}) {
    return AttendanceState(
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage,
        successMessage: successMessage,
        currentAttendance: currentAttendance ?? this.currentAttendance,
        workType: workType ?? this.workType);
  }
}

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  final AttendanceService _attendanceService;

  AttendanceNotifier(this._attendanceService) : super(AttendanceState());

  Future<void> checkIn({
    required UserModel user,
    WorkType workType = WorkType.office,
  }) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    try {
      final officeLocation = await OfficeLocationService()
          .getOfficeLocation(user.officeLocationId);

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
          errorMessage: e.toString().replaceAll("Exception:", ""));
    }
  }

  Future<void> checkOut({
    required UserModel user,
    required AttendanceModel todayAttendance,
  }) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    try {
      final officeLocation = await OfficeLocationService()
          .getOfficeLocation(user.officeLocationId);

      if (officeLocation == null) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'Office location not found');
        return;
      }

      final result = await _attendanceService.checkOut(
          user: user,
          officeLocation: officeLocation,
          todayAttendance: todayAttendance);

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
        errorMessage: e.toString().replaceAll("Exception:", ""),
      );
    }
  }

  void setWorkType(WorkType workType) {
    state = state.copyWith(workType: workType);
  }
}

final attendanceNotifierProvider =
    StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  final attendanceService = ref.watch(attendanceServiceProvider);
  return AttendanceNotifier(attendanceService);
});
