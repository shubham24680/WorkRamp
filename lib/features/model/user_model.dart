enum UserRole { admin, hr, manager, employee }

enum Department { technology, hr, sales, marketing, finance, operations }

class UserModel {
  final String userId;
  final String email;
  final String name;
  final String? phone;
  final String? profileImage;
  final Department department;
  final String designation;
  final UserRole role;
  final String? managerId;
  final String employeeId;
  final String officeLocationId;
  final bool canCheckInAnywhere;
  final DateTime joinDate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    this.phone,
    this.profileImage,
    required this.department,
    required this.designation,
    required this.role,
    this.managerId,
    required this.employeeId,
    required this.officeLocationId,
    this.canCheckInAnywhere = false,
    required this.joinDate,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        userId: json['id'] ?? '',
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'],
        profileImage: json['profile_image'],
        department: Department.values.firstWhere(
          (e) => e.name == json['department'].toLowerCase(),
          orElse: () => Department.technology,
        ),
        designation: json['designation'] ?? '',
        role: UserRole.values.firstWhere(
          (e) => e.name == json['role'].toLowerCase(),
          orElse: () => UserRole.employee,
        ),
        managerId: json['manager_id'],
        employeeId: json['employee_id'] ?? '',
        officeLocationId: json['office_location_id'] ?? '',
        canCheckInAnywhere: json['can_check_in_anywhere'] ?? false,
        joinDate: json['join_date'] != null
            ? DateTime.parse(json['join_date'])
            : DateTime.now(),
        isActive: json['is_active'] ?? true,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );

  UserModel copyWith({
    String? userId,
    String? email,
    String? name,
    String? phone,
    String? profileImage,
    Department? department,
    String? designation,
    UserRole? role,
    String? managerId,
    String? employeeId,
    String? officeLocationId,
    bool? canCheckInAnywhere,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      UserModel(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        profileImage: profileImage ?? this.profileImage,
        department: department ?? this.department,
        designation: designation ?? this.designation,
        role: role ?? this.role,
        managerId: managerId ?? this.managerId,
        employeeId: employeeId ?? this.employeeId,
        officeLocationId: officeLocationId ?? this.officeLocationId,
        canCheckInAnywhere: canCheckInAnywhere ?? this.canCheckInAnywhere,
        joinDate: joinDate ?? this.joinDate,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  Map<String, dynamic> toJson() => {
        'id': userId,
        'email': email,
        'name': name,
        'phone': phone,
        'profileImage': profileImage,
        'department': department.name,
        'designation': designation,
        'role': role.name,
        'managerId': managerId,
        'employeeId': employeeId,
        'officeLocationId': officeLocationId,
        'canCheckInAnywhere': canCheckInAnywhere,
        'joinDate': joinDate.toUtc().toIso8601String(),
        'isActive': isActive,
        'createdAt': createdAt?.toUtc().toIso8601String(),
        'updatedAt': updatedAt?.toUtc().toIso8601String(),
      };
}
