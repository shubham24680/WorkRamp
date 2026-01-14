enum AttendanceStatus {
  present,
  absent,
  halfDay,
  leave,
  weekOff
}

enum WorkType {
  office,
  anyLocation,
}

class AttendanceModel {
  final String? attendanceId;
  final String userId;
  final DateTime date;
  final DateTime? checkInTime;
  final DateTime? checkOutTime;
  final double? checkInLat;
  final double? checkInLong;
  final double? checkOutLat;
  final double? checkOutLong;
  final String? checkInAddress;
  final String? checkOutAddress;
  final String officeLocationId;
  final WorkType workType;
  final AttendanceStatus status;
  final int? totalHours;
  final int? overtimeHours;
  final String? notes;
  final bool isRegularized;
  final String? regularizedBy;
  final DateTime? regularizedAt;

  AttendanceModel({
    this.attendanceId,
    required this.userId,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLat,
    this.checkOutLong,
    required this.officeLocationId,
    this.workType = WorkType.office,
    required this.status,
    this.totalHours,
    this.overtimeHours,
    this.notes,
    this.isRegularized = false,
    this.regularizedBy,
    this.regularizedAt,
    this.checkInLong,
    this.checkOutLat,
    this.checkInAddress,
    this.checkOutAddress,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['id'],
      userId: json['user_id'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']).toLocal() : DateTime.now(),
      checkInTime: json['check_in_time'] != null
          ? DateTime.parse(json['check_in_time']).toLocal()
          : null,
      checkOutTime: json['check_out_time'] != null
          ? DateTime.parse(json['check_out_time']).toLocal()
          : null,
      checkInLat: json['check_in_latitude'],
      checkInLong: json['check_in_longitude'],
      checkOutLat: json['check_out_latitude'],
      checkOutLong: json['check_out_longitude'],
      checkInAddress: json['check_in_address'],
      checkOutAddress: json['check_out_address'],
      officeLocationId: json['office_location_id'] ?? '',
      workType: WorkType.values.firstWhere(
        (e) => e.name == json['work_type'],
        orElse: () => WorkType.office),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AttendanceStatus.present),
      totalHours: json['total_hours']?.toInt(),
      overtimeHours: json['overtime_hours']?.toInt(),
      notes: json['notes'],
      isRegularized: json['is_regularized'] ?? false,
      regularizedBy: json['regularized_by'],
      regularizedAt: json['regularized_at'] != null
          ? DateTime.parse(json['regularized_at']).toLocal()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (attendanceId != null) 'id': attendanceId,
      'user_id': userId,
      'date': date?.toUtc().toIso8601String(),
      'check_in_time': checkInTime?.toUtc().toIso8601String(),
      'check_out_time': checkOutTime?.toUtc().toIso8601String(),
      'check_in_latitude': checkInLat,
      'check_in_longitude': checkInLong,
      'check_out_latitude': checkOutLat,
      'check_out_longitude': checkOutLong,
      'check_in_address': checkInAddress,
      'check_out_address': checkOutAddress,
      'office_location_id': officeLocationId,
      'work_type': workType.name,
      'status': status.name,
      'total_hours': totalHours,
      'overtime_hours': overtimeHours,
      'notes': notes,
      'is_regularized': isRegularized,
      'regularized_by': regularizedBy,
      'regularized_at': regularizedAt?.toUtc().toIso8601String(),
    };
  }

  AttendanceModel copyWith({
    String? attendanceId,
    String? userId,
    DateTime? date,
    DateTime? checkInTime,
    DateTime? checkOutTime,
    double? checkInLat,
    double? checkInLong,
    double? checkOutLat,
    double? checkOutLong,
    String? checkInAddress,
    String? checkOutAddress,
    String? officeLocationId,
    WorkType? workType,
    AttendanceStatus? status,
    int? totalHours,
    int? overtimeHours,
    String? notes,
    bool? isRegularized,
    String? regularizedBy,
    DateTime? regularizedAt,
  }) {
    return AttendanceModel(
      attendanceId: attendanceId ?? this.attendanceId,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      checkInLat: checkInLat ?? this.checkInLat,
      checkInLong: checkInLong ?? this.checkInLong,
      checkOutLat: checkOutLat ?? this.checkOutLat,
      checkOutLong: checkOutLong ?? this.checkOutLong,
      checkInAddress: checkInAddress ?? this.checkInAddress,
      checkOutAddress: checkOutAddress ?? this.checkOutAddress,
      officeLocationId: officeLocationId ?? this.officeLocationId,
      workType: workType ?? this.workType,
      status: status ?? this.status,
      totalHours: totalHours ?? this.totalHours,
      overtimeHours: overtimeHours ?? this.overtimeHours,
      notes: notes ?? this.notes,
      isRegularized: isRegularized ?? this.isRegularized,
      regularizedBy: regularizedBy ?? this.regularizedBy,
      regularizedAt: regularizedAt ?? this.regularizedAt,
    );
  }
}
