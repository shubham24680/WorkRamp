import 'dart:developer';

import 'package:intl/intl.dart';

import '../../app.dart';

class AttendanceService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final LocationService _locationService = LocationService();

  // Check if user has already checked in today
  Future<AttendanceModel?> getTodayAttendance(String userId) async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await _supabase
          .from('attendance')
          .select()
          .eq('user_id', userId)
          .gte('date', startOfDay.toUtc().toIso8601String())
          .maybeSingle();

      log("Today Attendance - $startOfDay, $endOfDay: $response");
      return (response == null) ? null: AttendanceModel.fromJson(response);
    } catch (e) {
      print('Error getting today attendance: $e');
      return null;
    }
  }

  // Check in
  Future<CheckInResult> checkIn({
    required UserModel user,
    required OfficeLocation officeLocation,
    WorkType workType = WorkType.office,
  }) async {
    try {
      // Check if already checked in today
      final todayAttendance = await getTodayAttendance(user.userId);
      if (todayAttendance != null && todayAttendance.checkInTime != null) {
        return CheckInResult(
          success: false,
          message: 'You have already checked in today',
        );
      }

      // Get current location
      Position? position;
      LocationData? locationData;

      try {
        position = await _locationService.getCurrentLocation();
        debugPrint(
            "CURRENT LOCATION - Lat ${position?.latitude} Long ${position?.longitude}\nOFFICE LOCATION - Lat ${officeLocation.latitude}, Long ${officeLocation.longitude}");
        if (position != null) {
          locationData = await _locationService.createLocationData(position);
        }
      } catch (e) {
        return CheckInResult(
          success: false,
          message: 'Failed to get location: ${e.toString()}',
        );
      }

      if (position == null || locationData == null) {
        return CheckInResult(
          success: false,
          message: 'Unable to get your current location',
        );
      }

      // Validate location if required
      if (!user.canCheckInAnywhere) {
        final validation = await _locationService.validateCheckIn(
          currentPosition: position,
          officeLocation: officeLocation,
          canCheckInAnywhere: user.canCheckInAnywhere,
        );

        if (!validation.isValid) {
          return CheckInResult(
            success: false,
            message: validation.message,
            currentLocation: locationData,
          );
        }
      }

      // Create attendance record
      final now = DateTime.now();
      final attendance = AttendanceModel(
        userId: user.userId,
        date: now,
        checkInTime: now,
        checkInLat: locationData.latitude,
        checkInLong: locationData.longitude,
        checkInAddress: locationData.address,
        officeLocationId: officeLocation.locationId,
        workType: workType,
        status: AttendanceStatus.present,
      );

      await _supabase.from('attendance').insert(attendance.toJson());

      return CheckInResult(
        success: true,
        message:
            'Checked in successfully at ${DateFormat('hh:mm a').format(now)}',
        attendance: attendance,
        currentLocation: locationData,
      );
    } catch (e) {
      print('Error checking in: $e');
      return CheckInResult(
        success: false,
        message: 'Failed to check in: ${e.toString()}',
      );
    }
  }

  // Check out
  Future<CheckOutResult> checkOut({
    required UserModel user,
    required AttendanceModel todayAttendance,
  }) async {
    try {
      // Get current location
      Position? position;
      LocationData? locationData;

      try {
        position = await _locationService.getCurrentLocation();
        if (position != null) {
          locationData = await _locationService.createLocationData(position);
        }
      } catch (e) {
        print('Location error during checkout: $e');
        // Continue with checkout even if location fails
      }

      final now = DateTime.now();

      // Calculate total hours
      double? totalHours;
      double? overtimeHours;
      if (todayAttendance.checkInTime != null) {
        final duration = now.difference(todayAttendance.checkInTime!);
        totalHours = duration.inMinutes / 60.0;

        // Calculate overtime (assuming 9 hours is standard)
        const standardHours = 9.0;
        if (totalHours > standardHours) {
          overtimeHours = totalHours - standardHours;
        }
      }
      log("WORKING HR. - $totalHours, $overtimeHours");

      // Update attendance record
      final updatedAttendance = todayAttendance.copyWith(
        checkOutTime: now,
        checkOutLat: locationData?.latitude,
        checkOutLong: locationData?.longitude,
        checkOutAddress: locationData?.address,
        totalHours: totalHours,
        overtimeHours: overtimeHours,
      );

      final id = todayAttendance.attendanceId;
      if(id == null) {
        return CheckOutResult(
          success: false,
          message: 'Failed to check out: CHECKOUT',
        );
      }

      final response = updatedAttendance.toJson();
      log("UPDATED ATTENDANCE - $response, ID - $id");
      await _supabase
          .from('attendance')
          .update(response)
          .eq('id', id);

      return CheckOutResult(
        success: true,
        message:
            'Checked out successfully at ${DateFormat('hh:mm a').format(now)}',
        attendance: updatedAttendance,
        currentLocation: locationData,
        totalHours: totalHours,
      );
    } catch (e) {
      print('Error checking out: $e');
      return CheckOutResult(
        success: false,
        message: 'Failed to check out: ${e.toString()}',
      );
    }
  }

  // Get attendance history for a user
  Future<List<AttendanceModel>> getAttendanceHistory({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 30,
  }) async {
    try {
      var query = _supabase.from('attendance').select().eq('user_id', userId);

      if (startDate != null) {
        query = query.gte('date', startDate.toIso8601String());
      }
      if (endDate != null) {
        query = query.lte('date', endDate.toIso8601String());
      }

      final response = await query.order('date', ascending: false).limit(limit);
      return (response as List)
          .map((item) => AttendanceModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error getting attendance history: $e');
      return [];
    }
  }

  // Get monthly attendance summary
  Future<AttendanceSummary> getMonthlyAttendanceSummary({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final startDate = DateTime(year, month, 1);
      final endDate = DateTime(year, month + 1, 0);

      final attendances = await getAttendanceHistory(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        limit: 31,
      );

      int presentDays = 0;
      int absentDays = 0;
      int lateDays = 0;
      double totalWorkHours = 0;
      double totalOvertimeHours = 0;

      for (var attendance in attendances) {
        if (attendance.status == AttendanceStatus.present) {
          presentDays++;
        } else if (attendance.status == AttendanceStatus.absent) {
          absentDays++;
        } else if (attendance.status == AttendanceStatus.late) {
          lateDays++;
        }

        if (attendance.totalHours != null) {
          totalWorkHours += attendance.totalHours!;
        }
        if (attendance.overtimeHours != null) {
          totalOvertimeHours += attendance.overtimeHours!;
        }
      }

      final totalDays = endDate.day;
      final attendancePercentage = (presentDays / totalDays) * 100;

      return AttendanceSummary(
        month: month,
        year: year,
        presentDays: presentDays,
        absentDays: absentDays,
        lateDays: lateDays,
        totalWorkHours: totalWorkHours,
        totalOvertimeHours: totalOvertimeHours,
        attendancePercentage: attendancePercentage,
        attendances: attendances,
      );
    } catch (e) {
      print('Error getting monthly summary: $e');
      return AttendanceSummary(
        month: month,
        year: year,
        presentDays: 0,
        absentDays: 0,
        lateDays: 0,
        totalWorkHours: 0,
        totalOvertimeHours: 0,
        attendancePercentage: 0,
        attendances: [],
      );
    }
  }
}

// Result classes
class CheckInResult {
  final bool success;
  final String message;
  final AttendanceModel? attendance;
  final LocationData? currentLocation;

  CheckInResult({
    required this.success,
    required this.message,
    this.attendance,
    this.currentLocation,
  });
}

class CheckOutResult {
  final bool success;
  final String message;
  final AttendanceModel? attendance;
  final LocationData? currentLocation;
  final double? totalHours;

  CheckOutResult({
    required this.success,
    required this.message,
    this.attendance,
    this.currentLocation,
    this.totalHours,
  });
}

class AttendanceSummary {
  final int month;
  final int year;
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final double totalWorkHours;
  final double totalOvertimeHours;
  final double attendancePercentage;
  final List<AttendanceModel> attendances;

  AttendanceSummary({
    required this.month,
    required this.year,
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.totalWorkHours,
    required this.totalOvertimeHours,
    required this.attendancePercentage,
    required this.attendances,
  });
}
