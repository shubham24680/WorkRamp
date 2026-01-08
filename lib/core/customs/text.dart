import '../../app.dart';

enum Family { INTER, QUICKSAND, DANCING_SCRIPT }

class CustomText extends StatelessWidget {
  const CustomText(
      {super.key,
      required this.text,
      this.align,
      this.maxLines,
      this.overflow,
      this.family = Family.INTER,
      this.color,
      this.size,
      this.weight,
      this.height,
      this.capitalFirstWord = false});

  final String text;
  final TextAlign? align;
  final int? maxLines;
  final TextOverflow? overflow;
  final Family family;
  final Color? color;
  final double? size;
  final FontWeight? weight;
  final double? height;
  final bool capitalFirstWord;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: getTextStyle(),
    );
  }

  TextStyle getTextStyle() {
    switch (family) {
      case Family.QUICKSAND:
        return GoogleFonts.quicksand(
          color: color,
          fontSize: size ?? 14.w,
          fontWeight: weight,
          height: height,
        );
      case Family.DANCING_SCRIPT:
        return GoogleFonts.dancingScript(
          color: color,
          fontSize: size ?? 14.w,
          fontWeight: weight,
          height: height,
        );
      default:
        return GoogleFonts.inter(
          color: color,
          fontSize: size ?? 14.w,
          fontWeight: weight,
          height: height,
        );
    }
  }
}
