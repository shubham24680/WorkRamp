import 'dart:developer';

import '../../app.dart';

final profileProvider = FutureProvider<UserModel>((ref) async {
  final user = EmailAuthService().currentUser;

  log("Current User - $user");
  if (user == null) throw Exception;

  return await EmailAuthService().getUserProfile(user.id);
});
