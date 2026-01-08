import '../../app.dart';

class CustomContainer extends StatelessWidget {
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final double? height;
  final double? width;
  final Color? color;
  final BorderRadius? borderRadius;
  final Widget? child;
  final void Function()? event;
  final double? blurRadius;
  final Color? shadowColor;
  final Offset? offset;
  final String? imageUrl;
  final BoxFit? fit;
  final Alignment begin;
  final Alignment end;
  final List<Color>? gradient;

  const CustomContainer(
      {super.key,
      this.margin,
      this.padding,
      this.height,
      this.width,
      this.color,
      this.borderRadius,
      this.child,
      this.event,
      this.blurRadius,
      this.shadowColor,
      this.offset,
      this.imageUrl,
      this.fit,
      this.begin = Alignment.topLeft,
      this.end = Alignment.bottomRight,
      this.gradient});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          image: (imageUrl != null)
              ? DecorationImage(
                  image: AssetImage(imageUrl ?? ""), fit: fit ?? BoxFit.cover)
              : null,
          boxShadow: [
            BoxShadow(
              color: shadowColor ?? Colors.transparent,
              offset: offset ?? Offset.zero,
              blurRadius: blurRadius ?? 0.0,
            )
          ],
          gradient: (gradient != null && gradient!.isNotEmpty)
              ? LinearGradient(
                  begin: begin,
                  end: end,
                  colors: gradient ??
                      [
                        AppColor.blue_1,
                        AppColor.blue_2,
                      ])
              : null),
      child: child,
    ).onTap(event: event ?? () {});
  }
}
