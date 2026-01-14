import 'dart:developer';
import '../../app.dart';

class AuthenticationState {
  final bool isLoading;
  final String? statusCode;
  final String? errorMessage;
  final AuthResponse user;

  AuthenticationState(
      {required this.isLoading,
      required this.statusCode,
      required this.errorMessage,
      required this.user});

  AuthenticationState.initial()
      : isLoading = false,
        statusCode = null,
        errorMessage = null,
        user = AuthResponse(user: null);

  AuthenticationState copyWith({
    bool? isLoading,
    String? statusCode,
    String? errorMessage,
    AuthResponse? user,
  }) =>
      AuthenticationState(
          isLoading: isLoading ?? this.isLoading,
          statusCode: statusCode,
          errorMessage: errorMessage,
          user: user ?? this.user);
}

class AuthNotifier extends StateNotifier<AuthenticationState> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthenticationState.initial());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final auth =
          await EmailAuthService().signIn(email: email, password: password);
      log("Auth Notifier - Sign In - $auth");
      state = state.copyWith(user: auth, isLoading: false);
    } on AuthException catch (e) {
      state = state.copyWith(
          statusCode: e.statusCode, errorMessage: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      final isEmailExist = await EmailAuthService().isEmailExists(email);
      if (isEmailExist) {
        state = state.copyWith(
            errorMessage: "Email already exists", isLoading: false);
        return;
      }

      final auth =
          await EmailAuthService().signUp(email: email, password: password);
      state = state.copyWith(user: auth, isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    try {
      await EmailAuthService().signOut();
      await MyAppProviders.invalidateAllProviders(ref);
      state = state.copyWith(user: AuthResponse(user: null), isLoading: false);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthenticationState>(
    (ref) => AuthNotifier(ref));

final currentUserProvider = StreamProvider<User?>((ref) {
  return EmailAuthService()
      .authStateChanges
      .map((event) => event.session?.user);
});
