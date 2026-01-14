import 'dart:developer';

import '../../app.dart';

class UserService {
  UserService._();

  factory UserService() => _instance;
  static final UserService _instance = UserService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get user profile
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _supabase
          .from(ApiConstants.USERS_SERVICE)
          .select()
          .eq("id", userId)
          .single();

      log("User profile Response - $response");
      return UserModel.fromJson(response);
    } catch (e) {
      log('Error getting user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  // Future<void> updateUserProfile(UserModel user) async {
  //   try {
  //     await _supabase.from('users').update(user.toJson()).eq('id', user.userId);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
