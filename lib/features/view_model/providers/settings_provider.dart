import 'dart:developer';
import 'package:flutter/material.dart';

import '../../../core/services/settings_curd.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsDB _db = SettingsDB();
  String _changedAvatar = "assets/avatars/settings.svg";
  String _selectedAvatar = "assets/avatars/settings.svg";
  final List<String> _avatar = [
    "assets/avatars/settings.svg",
    "assets/avatars/avatar (1).svg",
    "assets/avatars/avatar (2).svg",
    "assets/avatars/avatar (3).svg",
    "assets/avatars/avatar (4).svg",
    "assets/avatars/avatar (5).svg",
    "assets/avatars/avatar (6).svg",
    "assets/avatars/avatar (7).svg",
    "assets/avatars/avatar (8).svg",
    "assets/avatars/avatar (9).svg",
    "assets/avatars/avatar (10).svg",
  ];

  bool _isFetch = false;

  List<String> get avatar => _avatar;
  String get changedAvatar => _changedAvatar;
  String get selectedAvatar => _selectedAvatar;
  bool get isFetch => _isFetch;

  void fetchAvatar() async {
    if (_isFetch) {
      return;
    }

    try {
      final response = await _db.read();
      if (response != null) {
        _changedAvatar = response[0]["avatar"] as String;
        _selectedAvatar = _changedAvatar;
      }
    } catch (e) {
      log(e.toString());
    } finally {
      _isFetch = true;
      notifyListeners();
    }
  }

  void changeYourAvatar(int index) {
    _changedAvatar = _avatar[index];
    notifyListeners();
  }

  void selectYourAvatar() async {
    _selectedAvatar = _changedAvatar;
    notifyListeners();
    await _db.update(selectedAvatar);
  }

  void clearSetting() {
    log("clear Setting");
    _changedAvatar = "assets/avatars/settings.svg";
    _selectedAvatar = "assets/avatars/settings.svg";
    _isFetch = false;
    notifyListeners();
  }
}
