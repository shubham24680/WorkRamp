import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsDB {
  static final _supabase = Supabase.instance.client.from("Profiles");
  static final String _userId = Supabase.instance.client.auth.currentUser!.id;

  static create() async {
    final response =
        await _supabase.select("uid").eq("uid", _userId).maybeSingle();
    if (response == null) {
      await _supabase.insert({"avatar": "assets/avatars/settings.svg"});
      log("created Avatar");
    }
  }

  update(String avatar) async {
    await _supabase.update({"avatar": avatar}).eq("uid", _userId);
    log("Avatar updated");
  }

  read() async {
    log("read Avatar");
    return await _supabase.select("avatar");
  }
}
