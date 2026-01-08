import '../../app.dart';

class RolePermissions {
  static bool canManageLocations(UserRole role) {
    return role == UserRole.admin || role == UserRole.hr;
  }

  static bool canManageUsers(UserRole role) {
    return role == UserRole.admin || role == UserRole.hr;
  }

  static bool canViewAllAttendance(UserRole role) {
    return role == UserRole.admin ||
        role == UserRole.hr ||
        role == UserRole.manager;
  }

  static bool requiresLocationValidation(UserModel user) {
    if (user.canCheckInAnywhere) {
      return false;
    }

    return true;
  }

  static bool canApproveAttendance(UserRole role) {
    return role == UserRole.manager ||
        role == UserRole.hr ||
        role == UserRole.admin;
  }

  static bool canExportReports(UserRole role) {
    return role == UserRole.manager ||
        role == UserRole.hr ||
        role == UserRole.admin;
  }
}
