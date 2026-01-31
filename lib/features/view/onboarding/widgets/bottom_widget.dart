import 'dart:developer';
import '../../../../app.dart';

class BottomWidget extends ConsumerWidget {
  const BottomWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPadding = ScreenUtil().bottomBarHeight + 32.w;

    return CustomContainer(
        padding: EdgeInsets.only(
            left: 16.w, top: 32.w, right: 16.w, bottom: bottomPadding),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.r)),
        shadowColor: Colors.black.withAlpha(100),
        offset: Offset(0, -8),
        blurRadius: 10.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          _buildTextArea(ref),
          SizedBox(height: 32.w),
          _buildButtonArea(context, ref)
        ]));
  }

  Widget _buildTextArea(WidgetRef ref) {
    final onboardingState = ref.watch(onboardingProvider);
    final onboardingNotifier = ref.watch(onboardingProvider.notifier);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildTitle("Email Address"),
      CustomTextField(
          controller: onboardingState.emailController,
          filled: true,
          hintText: "Email123@gmail.com",
          keyboardType: TextInputType.emailAddress,
          errorText: onboardingState.emailErrorText),
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
          ? Align(
              alignment: Alignment.centerRight,
              child: _buildCondition("Forgot Password?"))
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
                      errorText: onboardingState.confirmPasswordErrorText)
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
                      size: 16.w,
                      weight: FontWeight.w600),
                  onPressed: () async =>
                      await onboardingNotifier.handleSubmit(ref)),
              SizedBox(height: 16.w),
              // Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              //   _buildCondition("Cookie Policy",
              //       event: () => context.push('/privacy_policy')),
              //   _buildCondition("Terms of Use",
              //       event: () => context.push('/terms')),
              //   _buildCondition("Privacy Policy", event: () {
              //     log("Privacy Policy");
              //     context.push('/privacy_policy');
              //   })
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
