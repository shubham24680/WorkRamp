enum LeaveType {
  casual("Casual"),
  sick("Sick"),
  annual("Annual"),
  unpaid("Unpaid");

  final String value;

  const LeaveType(this.value);
}

enum LeaveStatus {
  pending("Pending"),
  approved("Approved"),
  rejected("Rejected"),
  cancelled("Cancelled");

  final String value;

  const LeaveStatus(this.value);
}

class LeaveModel {
  final String? leaveId;
  final String userId;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final double numberOfDays;
  final String reason;
  final LeaveStatus status;
  final DateTime appliedDate;
  final String? approvedBy;
  final DateTime? approvalDate;
  final String? rejectionReason;
  final bool isHalfDay;

  LeaveModel({
    this.leaveId,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.numberOfDays,
    required this.reason,
    required this.status,
    required this.appliedDate,
    this.approvedBy,
    this.approvalDate,
    this.rejectionReason,
    this.isHalfDay = false,
  });

  Map<String, dynamic> toJson() {
    return {
      if (leaveId != null) 'id': leaveId,
      'user_id': userId,
      'leave_type': leaveType.name,
      'start_date': startDate.toUtc().toIso8601String(),
      'end_date': endDate.toUtc().toIso8601String(),
      'number_of_days': numberOfDays,
      'reason': reason,
      'status': status.name,
      'applied_date': appliedDate.toUtc().toIso8601String(),
      'approved_by': approvedBy,
      'approval_date': approvalDate?.toUtc().toIso8601String(),
      'rejection_reason': rejectionReason,
      'is_half_day': isHalfDay,
    };
  }

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      leaveId: json['id'],
      userId: json['user_id'] ?? '',
      leaveType: LeaveType.values.firstWhere(
        (e) => e.name == json['leave_type'],
        orElse: () => LeaveType.casual,
      ),
      startDate: DateTime.parse(json['start_date']).toLocal(),
      endDate: DateTime.parse(json['end_date']).toLocal(),
      numberOfDays: json['number_of_days']?.toDouble() ?? 0.0,
      reason: json['reason'] ?? '',
      status: LeaveStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => LeaveStatus.pending,
      ),
      appliedDate: DateTime.parse(json['applied_date']).toLocal(),
      approvedBy: json['approved_by'],
      approvalDate: json['approval_date'] != null
          ? DateTime.parse(json['approval_date']).toLocal()
          : null,
      rejectionReason: json['rejection_reason'],
      isHalfDay: json['is_half_day'] ?? false,
    );
  }

  LeaveModel copyWith({
    String? leaveId,
    String? userId,
    LeaveType? leaveType,
    DateTime? startDate,
    DateTime? endDate,
    double? numberOfDays,
    String? reason,
    LeaveStatus? status,
    DateTime? appliedDate,
    String? approvedBy,
    DateTime? approvalDate,
    String? rejectionReason,
    bool? isHalfDay,
  }) {
    return LeaveModel(
      leaveId: leaveId ?? this.leaveId,
      userId: userId ?? this.userId,
      leaveType: leaveType ?? this.leaveType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      appliedDate: appliedDate ?? this.appliedDate,
      approvedBy: approvedBy ?? this.approvedBy,
      approvalDate: approvalDate ?? this.approvalDate,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      isHalfDay: isHalfDay ?? this.isHalfDay,
    );
  }
}

class LeaveBalanceModel {
  final String userId;
  final int year;
  final double casualLeave;
  final double sickLeave;
  final double annualLeave;
  final double unpaidLeave;
  final double casualLeaveUsed;
  final double sickLeaveUsed;
  final double annualLeaveUsed;
  final double unpaidLeaveUsed;

  LeaveBalanceModel({
    required this.userId,
    required this.year,
    required this.casualLeave,
    required this.sickLeave,
    required this.annualLeave,
    this.unpaidLeave = 0,
    this.casualLeaveUsed = 0,
    this.sickLeaveUsed = 0,
    this.annualLeaveUsed = 0,
    this.unpaidLeaveUsed = 0,
  });

  double get casualLeaveRemaining => casualLeave - casualLeaveUsed;

  double get sickLeaveRemaining => sickLeave - sickLeaveUsed;

  double get annualLeaveRemaining => annualLeave - annualLeaveUsed;

  double get totalLeaveRemaining =>
      casualLeaveRemaining + sickLeaveRemaining + annualLeaveRemaining;

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'year': year,
      'casual_leave': casualLeave,
      'sick_leave': sickLeave,
      'annual_leave': annualLeave,
      'unpaid_leave': unpaidLeave,
      'casual_leave_used': casualLeaveUsed,
      'sick_leave_used': sickLeaveUsed,
      'annual_leave_used': annualLeaveUsed,
      'unpaid_leave_used': unpaidLeaveUsed,
    };
  }

  factory LeaveBalanceModel.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceModel(
      userId: json['user_id'] ?? '',
      year: json['year'] ?? DateTime.now().year,
      casualLeave: json['casual_leave']?.toDouble() ?? 0.0,
      sickLeave: json['sick_leave']?.toDouble() ?? 0.0,
      annualLeave: json['annual_leave']?.toDouble() ?? 0.0,
      unpaidLeave: json['unpaid_leave']?.toDouble() ?? 0.0,
      casualLeaveUsed: json['casual_leave_used']?.toDouble() ?? 0.0,
      sickLeaveUsed: json['sick_leave_used']?.toDouble() ?? 0.0,
      annualLeaveUsed: json['annual_leave_used']?.toDouble() ?? 0.0,
      unpaidLeaveUsed: json['unpaid_leave_used']?.toDouble() ?? 0.0,
    );
  }

  LeaveBalanceModel copyWith({
    String? userId,
    int? year,
    double? casualLeave,
    double? sickLeave,
    double? annualLeave,
    double? unpaidLeave,
    double? casualLeaveUsed,
    double? sickLeaveUsed,
    double? annualLeaveUsed,
    double? unpaidLeaveUsed,
  }) {
    return LeaveBalanceModel(
      userId: userId ?? this.userId,
      year: year ?? this.year,
      casualLeave: casualLeave ?? this.casualLeave,
      sickLeave: sickLeave ?? this.sickLeave,
      annualLeave: annualLeave ?? this.annualLeave,
      unpaidLeave: unpaidLeave ?? this.unpaidLeave,
      casualLeaveUsed: casualLeaveUsed ?? this.casualLeaveUsed,
      sickLeaveUsed: sickLeaveUsed ?? this.sickLeaveUsed,
      annualLeaveUsed: annualLeaveUsed ?? this.annualLeaveUsed,
      unpaidLeaveUsed: unpaidLeaveUsed ?? this.unpaidLeaveUsed,
    );
  }
}
