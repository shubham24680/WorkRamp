import 'dart:developer';

import '../../app.dart';

final locationProvider = FutureProvider<OfficeLocation>((ref) async {
  final officeLocationId = ref.watch(profileProvider).value?.officeLocationId;

  log("[LOCATION PROVIDER] Location Id - $officeLocationId");
  if (officeLocationId == null) throw Exception;

  return await EmailAuthService().getOfficeLocation(officeLocationId);
});
