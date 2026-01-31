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
      WorkType? workType,
      bool? locationPermission}) {
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

  Future<void> checkIn({required UserModel user}) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, successMessage: null);

    try {
      final officeLocation = await OfficeLocationService()
          .getOfficeLocation(user.officeLocationId);
      final isLocationEnabled =
          await LocationService().isLocationServiceEnabled();

      if (!isLocationEnabled) {
        state = state.copyWith(isLoading: false, errorMessage: 'location');
        return;
      }

      // Perform check-in
      final result = await _attendanceService.checkIn(
        user: user,
        officeLocation: officeLocation,
        workType: state.workType,
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
      final isLocationEnabled =
          await LocationService().isLocationServiceEnabled();

      if (!isLocationEnabled) {
        state = state.copyWith(
            isLoading: false, errorMessage: 'location');
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

  Future<void> openLocationSettings() async {
    await LocationService().openLocationSettings();
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
