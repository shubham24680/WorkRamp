import '../../app.dart';

enum ScreenType {
  LOADING,
  ERROR,
  VERIFY
}

class AlertScreen extends StatelessWidget {
  const AlertScreen({super.key, this.type = ScreenType.LOADING});

  final ScreenType type;

  @override
  Widget build(BuildContext context) {
    String image;
    String? text;

    switch (type) {
      case ScreenType.ERROR:
        image = AppLotties.ERROR;
        text = "Something went wrong!";
        break;
        case ScreenType.VERIFY:
        image = AppLotties.VERIFY;
        text = "Hang tight!\nWe’re verifying your details.";
        break;
      default:
        image = AppLotties.LOADING;
        break;
    }

    return Scaffold(
        body: SizedBox(
            width: 1.sw,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Lottie.asset(image),
              if (text != null)
                CustomText(
                    text: text,
                    align: TextAlign.center,
                    weight: FontWeight.w600)
            ])));
  }
}
