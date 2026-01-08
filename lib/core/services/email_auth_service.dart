import 'dart:developer';

import '../../app.dart';

class EmailAuthService {
  EmailAuthService._();

  factory EmailAuthService() => _instance;
  static final EmailAuthService _instance = EmailAuthService._();

  final SupabaseClient _supabase = Supabase.instance.client;

  // Get current user
  User? get currentUser => _supabase.auth.currentUser;

  // Auth state changes stream
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign up
  Future<AuthResponse> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth
          .signInWithPassword(email: email, password: password);
      log("Sign In Response - $response");
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  // Get user profile
  Future<UserModel> getUserProfile(String userId) async {
    try {
      final response = await _supabase.from(ApiConstants.USERS_SERVICE).select().eq("id", userId).single();

      log("User profile Response - $response");
      return UserModel.fromJson(response);
    } catch (e) {
      log('Error getting user profile: $e');
      rethrow;
    }
  }

  // Get user profile
  Future<OfficeLocation> getOfficeLocation(String locationId) async {
    try {
      final response = await _supabase.from(ApiConstants.OFFICE_SERVICE).select().eq("id", locationId).single();

      log("Office Location Response - $response");
      return OfficeLocation.fromJson(response);
    } catch (e) {
      log('Error getting office location: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _supabase.from('users').update(user.toJson()).eq('id', user.userId);
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  // Check if email exists
  Future<bool> isEmailExists(String email) async {
    try {
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .maybeSingle();

      return response != null;
    } catch (e) {
      return false;
    }
  }
}
