import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tickit/core/constants/api_constants.dart';

import 'settings_curd.dart';

class GoogleService {
  static final _supabase = Supabase.instance.client;

  /// Web Client ID that you registered with Google Cloud.
  static final String _webClientId = ApiConstants.WEB_CLIENT_ID;

  // iOS Client ID that you registered with Google Cloud.
  static final String _iosClientId = ApiConstants.IOS_CLIENT_ID;

  // desktop Client ID that you registered with Google Cloud.
  static final String _desktopClientId = ApiConstants.DESKTOP_CLIENT_ID;

  // Google sign in on Android will work without providing the Android
  // Client ID registered on Google Cloud.
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: Platform.isWindows ? _desktopClientId : _iosClientId,
    serverClientId: _webClientId,
  );

  static Future<void> nativeSignInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      final auth = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      final Session? session = auth.session;
      if (session == null) {
        log("Login Failed");
        return;
      }

      log("Native Sign in successful");
      if (auth.user != null) {
        await SettingsDB.create();
      }

      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
      }
    } catch (e) {
      log("Error -> $e");
    }
  }

  static Future<void> webSignInWithGoogle(BuildContext context) async {
    try {
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
      );

      _supabase.auth.onAuthStateChange.listen((data) {
        final AuthChangeEvent event = data.event;
        if (event == AuthChangeEvent.signedIn && context.mounted) {
          log("Web Sign in successful");
          Navigator.pushNamedAndRemoveUntil(context, "/home", (_) => false);
        }
      });
    } catch (e) {
      log("Error -> $e");
    }
  }

  static Future<void> signOut(BuildContext context) async {
    log("Sign out successfully");
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, "/onboarding", (_) => false);
    }
  }
}
