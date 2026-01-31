import '../../app.dart';

class LeaveService {
  LeaveService._();

  static final LeaveService _instance = LeaveService._();

  factory LeaveService() => _instance;
  final SupabaseClient _supabase = Supabase.instance.client;

  // Check if user can apply for leave (sufficient balance)
  Future<bool> canApplyLeave({
    required String userId,
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required double numberOfDays,
  }) async {
    try {
      final response = await _supabase
          .from('leaves')
          .select()
          .eq('user_id', userId)
          .lte('start_date', endDate)
          .gte('end_date', startDate);
      if (response.isNotEmpty) {
        throw Exception("Leave already applied on this date range");
      }
      if (leaveType == LeaveType.unpaid) return true;

      final balance = await getLeaveBalance(userId);
      switch (leaveType) {
        case LeaveType.casual:
          return balance.casualLeaveRemaining >= numberOfDays;
        case LeaveType.sick:
          return balance.sickLeaveRemaining >= numberOfDays;
        case LeaveType.annual:
          return balance.annualLeaveRemaining >= numberOfDays;
        case LeaveType.unpaid:
          return true;
      }
    } catch (e) {
      rethrow;
    }
  }

  // Apply for leave
  Future<LeaveModel> applyLeave({
    required String userId,
    required LeaveType leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
    required bool isHalfDay,
  }) async {
    try {
      // Calculate number of days
      double numberOfDays =
      isHalfDay ? 0.5 : endDate
          .difference(startDate)
          .inDays + 1.0;

      final leave = LeaveModel(
        userId: userId,
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        numberOfDays: numberOfDays,
        reason: reason,
        status: LeaveStatus.pending,
        appliedDate: DateTime.now(),
        isHalfDay: isHalfDay,
      );

      final response = await _supabase
          .from('leaves')
          .insert(leave.toJson())
          .select()
          .single();

      final year = DateTime.now().year;
      final selectedLeaveType = leaveType.value.toLowerCase();
      final leaveBalance = await getLeaveBalance(userId);
      double? balance;
      switch (leaveType) {
        case LeaveType.casual:
          balance = leaveBalance.casualLeaveUsed;
          break;
        case LeaveType.sick:
          balance = leaveBalance.sickLeaveUsed;
          break;
        case LeaveType.annual:
          balance = leaveBalance.annualLeaveUsed;
          break;
        case LeaveType.unpaid:
          balance = leaveBalance.unpaidLeaveUsed;
          break;
      }
      await _supabase
          .from('leave_balance')
          .update({'${selectedLeaveType}_leave_used': balance + numberOfDays})
          .eq('user_id', userId)
          .eq('year', year);

      return LeaveModel.fromJson(response);
    } catch (e) {
      print('Error applying leave: $e');
      rethrow;
    }
  }

  // Get user's leave requests
  Future<List<LeaveModel>> getUserLeaves(String userId) async {
    try {
      final response = await _supabase
          .from('leaves')
          .select()
          .eq('user_id', userId)
          .order('applied_date', ascending: false);

      return (response as List)
          .map((item) => LeaveModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error getting user leaves: $e');
      return [];
    }
  }

  // // Get pending leaves for manager approval
  // Future<List<LeaveModel>> getPendingLeavesForApproval(String managerId) async {
  //   try {
  //     // Get team members
  //     final teamResponse = await _supabase
  //         .from('users')
  //         .select('id')
  //         .eq('manager_id', managerId);
  //
  //     final teamIds = (teamResponse as List).map((u) => u['id']).toList();
  //
  //     if (teamIds.isEmpty) return [];
  //
  //     final response = await _supabase
  //         .from('leaves')
  //         .select()
  //         .inFilter('user_id', teamIds)
  //         .eq('status', 'pending')
  //         .order('applied_date', ascending: false);
  //
  //     return (response as List)
  //         .map((item) => LeaveModel.fromJson(item))
  //         .toList();
  //   } catch (e) {
  //     print('Error getting pending leaves: $e');
  //     return [];
  //   }
  // }
  //
  // // Approve leave
  // Future<void> approveLeave(
  //     {required String leaveId, required String approverId}) async {
  //   try {
  //     await _supabase.from('leaves').update({
  //       'status': LeaveStatus.approved.name,
  //       'approved_by': approverId,
  //       'approval_date': DateTime.now().toIso8601String(),
  //     }).eq('id', leaveId);
  //   } catch (e) {
  //     print('Error approving leave: $e');
  //     rethrow;
  //   }
  // }
  //
  // // Reject leave
  // Future<void> rejectLeave({
  //   required String leaveId,
  //   required String approverId,
  //   required String reason,
  // }) async {
  //   try {
  //     await _supabase.from('leaves').update({
  //       'status': 'rejected',
  //       'approved_by': approverId,
  //       'approval_date': DateTime.now().toIso8601String(),
  //       'rejection_reason': reason,
  //     }).eq('id', leaveId);
  //   } catch (e) {
  //     print('Error rejecting leave: $e');
  //     rethrow;
  //   }
  // }
  //
  // // Cancel leave (by user)
  // Future<void> cancelLeave(String leaveId) async {
  //   try {
  //     await _supabase.from('leaves').update({
  //       'status': 'cancelled',
  //     }).eq('id', leaveId);
  //   } catch (e) {
  //     print('Error cancelling leave: $e');
  //     rethrow;
  //   }
  // }

  // Get leave balance
  Future<LeaveBalanceModel> getLeaveBalance(String userId) async {
    try {
      final year = DateTime
          .now()
          .year;
      final response = await _supabase
          .from('leave_balance')
          .select()
          .eq('user_id', userId)
          .eq('year', year)
          .maybeSingle();

      if (response == null) {
        return await _createDefaultLeaveBalance(userId, year);
      }

      return LeaveBalanceModel.fromJson(response);
    } catch (e) {
      print('Error getting leave balance: $e');
      rethrow;
    }
  }

  // Create default leave balance
  Future<LeaveBalanceModel> _createDefaultLeaveBalance(String userId,
      int year,) async {
    try {
      final balance = LeaveBalanceModel(
        userId: userId,
        year: year,
        casualLeave: 12.0,
        sickLeave: 12.0,
        annualLeave: 15.0,
      );

      await _supabase.from('leave_balance').insert(balance.toJson());
      return balance;
    } catch (e) {
      print('Error creating leave balance: $e');
      rethrow;
    }
  }

  // Get leave statistics
  Future<LeaveStatistics> getLeaveStatistics(String userId) async {
    try {
      final leaves = await getUserLeaves(userId);
      final balance = await getLeaveBalance(userId);

      int pendingCount =
          leaves
              .where((l) => l.status == LeaveStatus.pending)
              .length;
      int approvedCount =
          leaves
              .where((l) => l.status == LeaveStatus.approved)
              .length;
      int rejectedCount =
          leaves
              .where((l) => l.status == LeaveStatus.rejected)
              .length;

      double totalLeaveTaken = 0;
      for (var leave in leaves) {
        if (leave.status == LeaveStatus.approved) {
          totalLeaveTaken += leave.numberOfDays;
        }
      }

      return LeaveStatistics(
          pendingCount: pendingCount,
          approvedCount: approvedCount,
          rejectedCount: rejectedCount,
          totalLeaveTaken: totalLeaveTaken,
          leaveBalance: balance);
    } catch (e) {
      print('Error getting leave statistics: $e');
      rethrow;
    }
  }

  // Get upcoming leaves
  Future<List<LeaveModel>> getUpcomingLeaves(String userId) async {
    try {
      final today = DateTime.now();
      final response = await _supabase
          .from('leaves')
          .select()
          .eq('user_id', userId)
          .eq('status', LeaveStatus.approved.name)
          .gte('start_date', today.toUtc().toIso8601String())
          .order('start_date', ascending: true)
          .limit(5);

      return (response as List)
          .map((item) => LeaveModel.fromJson(item))
          .toList();
    } catch (e) {
      print('Error getting upcoming leaves: $e');
      return [];
    }
  }
}
