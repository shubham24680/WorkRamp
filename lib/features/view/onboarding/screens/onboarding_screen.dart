import '../../../../app.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomContainer(
            imageUrl: AppImages.ONBOARDING,
            event: () => FocusScope.of(context).unfocus(),
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              CustomText(
                  family: Family.DANCING_SCRIPT,
                  text: "WorkRamp",
                  size: 28.w,
                  color: AppColor.white,
                  weight: FontWeight.w900),
              SizedBox(height: 16.w),
              BottomWidget()
            ])));
  }
}
