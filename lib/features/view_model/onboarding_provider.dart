import 'dart:developer';

import '../../app.dart';

class OnboardingState {
  final bool isSignIn;
  final bool rememberMe;
  final bool isPasswordVisible;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController nameController;
  final TextEditingController confirmPasswordController;
  final String? emailErrorText;
  final String? passwordErrorText;
  final String? nameErrorText;
  final String? confirmPasswordErrorText;

  OnboardingState(
      {required this.emailController,
      required this.passwordController,
      required this.nameController,
      required this.confirmPasswordController,
      required this.isSignIn,
      required this.rememberMe,
      required this.isPasswordVisible,
      required this.emailErrorText,
      required this.passwordErrorText,
      required this.nameErrorText,
      required this.confirmPasswordErrorText});

  factory OnboardingState.initial() => OnboardingState(
      isSignIn: true,
      rememberMe: false,
      isPasswordVisible: false,
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      nameController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
      emailErrorText: null,
      passwordErrorText: null,
      nameErrorText: null,
      confirmPasswordErrorText: null);

  OnboardingState copyWith(
          {bool? isSignIn,
          bool? rememberMe,
          bool? isPasswordVisible,
          String? emailErrorText,
          String? passwordErrorText,
          String? nameErrorText,
          String? confirmPasswordErrorText}) =>
      OnboardingState(
          isSignIn: isSignIn ?? this.isSignIn,
          rememberMe: rememberMe ?? this.rememberMe,
          isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
          emailController: emailController,
          passwordController: passwordController,
          nameController: nameController,
          confirmPasswordController: confirmPasswordController,
          emailErrorText: emailErrorText,
          passwordErrorText: passwordErrorText,
          nameErrorText: nameErrorText,
          confirmPasswordErrorText: confirmPasswordErrorText);
}

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState.initial());

  void toggle() {
    state = state.copyWith(isSignIn: !state.isSignIn);
    state.confirmPasswordController.clear();
  }

  void toggleRememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  String? emailValidator() {
    final email = state.emailController.text.trim();

    String? errorText;
    if (email.isEmpty) {
      errorText = "Please enter email address";
    } else {
      final emailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      if (!emailValid) {
        errorText = "Invalid email address";
      }
    }

    return errorText;
  }

  String? passwordValidator() {
    final password = state.passwordController.text.trim();

    String? errorText;
    if (password.isEmpty) {
      errorText = "Please enter password";
    } else {
      final passwordValid = RegExp(
              r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
          .hasMatch(password);

      if (!passwordValid) {
        errorText =
            "Password must be at least 8 characters long and contain:\n "
            "- One uppercase letter\n"
            "- One lowercase letter\n"
            "- One number\n"
            "- One special character (!@#\$&*~)";
      }
    }

    return errorText;
  }

  String? confirmPasswordValidator() {
    final password = state.passwordController.text.trim();
    final confirmPassword = state.confirmPasswordController.text.trim();
    if (password.isEmpty ||
        confirmPassword.isEmpty ||
        password != confirmPassword) {
      return "Password does not match";
    }

    return null;
  }

  String? nameValidator() {
    final name = state.nameController.text.trim();

    if (name.isEmpty) {
      return "Please enter name";
    }

    return null;
  }

  Future<void> handleSubmit(WidgetRef ref) async {
    final email = emailValidator();
    final password = passwordValidator();
    final confirmPassword = confirmPasswordValidator();
    final name = nameValidator();

    state = state.copyWith(
        emailErrorText: email,
        passwordErrorText: password,
        nameErrorText: name,
        confirmPasswordErrorText: confirmPassword);

    if (state.isSignIn && email == null && password == null) {
      log("Sign in");
      await ref.read(authProvider.notifier).signIn(
          state.emailController.text.trim(),
          state.passwordController.text.trim());
    }

    if (!state.isSignIn &&
        email == null &&
        password == null &&
        confirmPassword == null) {
      log("Sign up");
      await ref.read(authProvider.notifier).signUp(
          state.emailController.text.trim(),
          state.passwordController.text.trim(),
          state.nameController.text.trim());
    }
  }
}

final onboardingProvider =
    StateNotifierProvider.autoDispose<OnboardingNotifier, OnboardingState>(
        (ref) => OnboardingNotifier());
