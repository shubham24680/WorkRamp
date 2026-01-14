import 'dart:developer';
import '../../app.dart';

final profileProvider = FutureProvider<UserModel>((ref) async {
  final user = EmailAuthService().currentUser;

  log("Current User - $user");
  if (user == null) throw Exception;

  return await UserService().getUserProfile(user.id);
});

final otherUserData =
    FutureProvider.family<UserModel, String>((ref, userId) async {
  return await UserService().getUserProfile(userId);
});
