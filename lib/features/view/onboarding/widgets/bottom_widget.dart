import 'dart:developer';

import '../../../../app.dart';

class BottomWidget extends ConsumerWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.watch(onboardingProvider.notifier);
    final bottomPadding = ScreenUtil().bottomBarHeight + 32.w;

    return CustomContainer(
        color: AppColor.white,
        padding: EdgeInsets.only(
            left: 16.w, top: 32.w, right: 16.w, bottom: bottomPadding),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        shadowColor: Colors.black.withAlpha(100),
        offset: Offset(0, -8),
        blurRadius: 10.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildTextArea(onboardingState, onboardingNotifier),
          SizedBox(height: 32.w),
          _buildButtonArea(context, ref)
        ]));
  }

  Widget _buildTextArea(
      OnboardingState onboardingState, OnboardingNotifier onboardingNotifier) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildTitle("Email Address"),
      CustomTextField(
        controller: onboardingState.emailController,
        filled: true,
        hintText: "Email123@gmail.com",
        keyboardType: TextInputType.emailAddress,
        errorText: onboardingState.emailErrorText,
      ),
      SizedBox(height: 16.w),
      _buildTitle("Password"),
      CustomTextField(
          controller: onboardingState.passwordController,
          filled: true,
          hintText: "xxxxxxxxxxxx",
          obscureText: !onboardingState.isPasswordVisible,
          suffixIcon: CustomImage(
                  imageType: ImageType.SVG_LOCAL,
                  onClick: () => onboardingNotifier.togglePasswordVisibility(),
                  imageUrl: onboardingState.isPasswordVisible
                      ? AppSvgs.EYE_OPEN
                      : AppSvgs.EYE_CLOSE,
                  color: Colors.grey.shade700)
              .paddingAll(4.w),
          errorText: onboardingState.passwordErrorText),
      (onboardingState.isSignIn)
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: [
                Checkbox(
                    value: onboardingState.rememberMe,
                    onChanged: (_) => onboardingNotifier.toggleRememberMe(),
                    activeColor: AppColor.blue_1,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
                _buildCondition("Remember me")
              ]),
              _buildCondition("Forgot Password?")
            ])
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  SizedBox(height: 16.w),
                  _buildTitle("Confirm Password"),
                  CustomTextField(
                    controller: onboardingState.confirmPasswordController,
                    filled: true,
                    hintText: "xxxxxxxxxxxx",
                    obscureText: !onboardingState.isPasswordVisible,
                    errorText: onboardingState.confirmPasswordErrorText,
                  ),
                  SizedBox(height: 16.w),
                  _buildTitle("Full Name"),
                  CustomTextField(
                      controller: onboardingState.nameController,
                      filled: true,
                      hintText: "WorkRamp",
                      errorText: onboardingState.nameErrorText)
                ])
    ]);
  }

  Widget _buildTitle(String text) {
    return CustomText(
        text: text,
        size: 12.w,
        color: AppColor.blue_1,
        weight: FontWeight.w600);
  }

  Widget _buildButtonArea(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.watch(onboardingProvider.notifier);

    ref.listen<AuthenticationState>(authProvider, (prev, next) {
      final errorMessage = authState.errorMessage;
      if (errorMessage != null) {
        log("Onboarding Error - $errorMessage");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(
                text: (authState.statusCode != null)
                    ? errorMessage
                    : "Something went wrong."),
            backgroundColor: Colors.red.shade700,
          ),
        );
      } else if (authState.user.user != null) {
        log("Onboarding Success");
        context.pushReplacement("/");
      }
    });

    return authState.isLoading
        ? CircularProgressIndicator(
            color: AppColor.blue_1, strokeCap: StrokeCap.round)
        : Column(
            children: [
              CustomButton(
                backgroundColor: AppColor.blue_1,
                borderRadius: 12.r,
                height: 50.w,
                child: CustomText(
                    text: onboardingState.isSignIn ? "Sign in" : "Sign up",
                    color: AppColor.white,
                    weight: FontWeight.w600),
                onPressed: () async {
                  log("Onboarding Button Clicked");
                  await onboardingNotifier.handleSubmit(ref);
                  log("Onboarding Process Complete");
                },
              ),
              SizedBox(height: 16.w),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //   _buildCondition("Cookie Policy"),
              //   _buildCondition("Terms of Use"),
              //   _buildCondition("Privacy Policy")
              // ]),
              // SizedBox(height: 32.w),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _buildCondition(onboardingState.isSignIn
                    ? "Don't have a account? "
                    : "Already have an account? "),
                _buildCondition(
                    onboardingState.isSignIn ? "Sign up" : "Sign in",
                    color: AppColor.blue_1,
                    event: () => onboardingNotifier.toggle())
              ])
            ],
          );
  }

  Widget _buildCondition(String text, {Color? color, void Function()? event}) {
    return CustomText(
            text: text,
            size: 10.w,
            color: color ?? Colors.grey.shade700,
            weight: FontWeight.w500)
        .onTap(event: event ?? () {});
  }
}
