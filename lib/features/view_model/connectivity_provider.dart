import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider extends ChangeNotifier {
  bool _isOffline = true;

  bool get isOffline => _isOffline;

  ConnectivityProvider() {
    checkConnectivity();
    Connectivity().onConnectivityChanged.listen((result) {
      updateConnectionStatus(result);
    });
  }

  Future<void> checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    updateConnectionStatus(result);
  }

  void updateConnectionStatus(List<ConnectivityResult> result) {
    _isOffline = result.contains(ConnectivityResult.none);
    log("Connection ${_isOffline ? "Offline" : "Online"}");
    notifyListeners();
  }
}
