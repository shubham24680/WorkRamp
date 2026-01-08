import '../../../../app.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomContainer(
            imageUrl: AppImages.ONBOARDING,
            event: () => FocusScope.of(context).unfocus(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomText(
                    family: Family.DANCING_SCRIPT,
                    text: "WorkRamp",
                    size: 28.w,
                    color: AppColor.white,
                    weight: FontWeight.w900),
                SizedBox(height: 16.w),
                BottomWidget()
              ],
            )));
  }
}

// LayoutBuilder(
// builder: (context, constraints) {
// final double height = constraints.maxHeight;
// final double width = constraints.maxWidth;
//
// if (constraints.maxWidth < 600) {
// return Column(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// logo,
// BottomContainer(
// height: height * 0.4,
// width: width,
// fontSize: height * 0.03,
// buttonSize: height * 0.17,
// ),
// ],
// );
// } else {
// return Row(
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// logo,
// BottomContainer(
// height: height,
// width: width * 0.4,
// fontSize: width * 0.03,
// buttonSize: width * 0.17,
// ),
// ],
// );
// }
// },
// ),
