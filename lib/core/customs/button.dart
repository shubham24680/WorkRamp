import '../../app.dart';

enum ButtonType { ELEVATED, ICON }

enum ButtonNature { BOUNDED, UNBOUNDED }

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.buttonType = ButtonType.ELEVATED,
      this.buttonNature = ButtonNature.UNBOUNDED,
      this.blurValue = 3.0,
      this.onPressed,
      this.borderRadius,
      this.backgroundColor,
      this.forgroundColor,
      this.height,
      this.width,
      this.child,
      this.icon});

  final ButtonType buttonType;
  final ButtonNature buttonNature;
  final double blurValue;
  final double? height;
  final double? width;
  final double? borderRadius;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? forgroundColor;
  final Widget? child;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    final widgetBackgroundColor =
        backgroundColor ?? AppColor.black5.withAlpha(40);
    final widgetBorderRadius = BorderRadius.circular(
        borderRadius ?? (buttonType == ButtonType.ICON ? 1.sh : 12.r));

    Size? getSize() {
      if (height != null && width != null) {
        return Size(width ?? 0, height ?? 0);
      } else if (height != null) {
        return Size.fromHeight(height ?? 0);
      } else if (width != null) {
        return Size.fromWidth(width ?? 0);
      }

      return null;
    }

    Widget baseButton;
    switch (buttonType) {
      case ButtonType.ICON:
        baseButton = IconButton(
            onPressed: onPressed,
            padding: EdgeInsets.all(2.w),
            constraints: buttonNature == ButtonNature.BOUNDED ? BoxConstraints() : null,
            style: IconButton.styleFrom(
                backgroundColor: widgetBackgroundColor,
                fixedSize: (height != null) ? Size(height ?? 0, height ?? 0) : null,
                shape: const CircleBorder()),
            icon: SvgPicture.asset(icon ?? AppSvgs.SETTINGS,
                colorFilter: ColorFilter.mode(
                    forgroundColor ?? AppColor.white.withAlpha(200),
                    BlendMode.srcIn)));
        break;
      default:
        baseButton = ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                backgroundColor: widgetBackgroundColor,
                minimumSize:
                    buttonNature == ButtonNature.BOUNDED ? null : getSize(),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: onPressed == null
                            ? AppColor.white.withAlpha(20)
                            : widgetBackgroundColor),
                    borderRadius: widgetBorderRadius)),
            child: child);
        break;
    }

    return blurEffect(
      blurValue,
      baseButton,
      borderRadius: widgetBorderRadius,
    );
  }
}
