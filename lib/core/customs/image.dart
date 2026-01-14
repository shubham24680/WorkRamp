import '../../app.dart';

enum ImageType {
  REMOTE,
  LOCAL,
  SVG_REMOTE,
  SVG_LOCAL,
  LOTTIE_LOCAL,
  LOTTIE_REMOTE
}

class CustomImage extends StatelessWidget {
  const CustomImage(
      {super.key,
      this.imageType = ImageType.LOCAL,
      this.imageUrl,
      this.borderRadius = BorderRadius.zero,
      this.placeholder,
      this.fit,
      this.height,
      this.width,
      this.onClick,
      this.color});

  final ImageType imageType;
  final String? imageUrl;
  final BorderRadius borderRadius;
  final Widget? placeholder;
  final BoxFit? fit;
  final double? height;
  final double? width;
  final void Function()? onClick;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Widget image;
    switch (imageType) {
      case ImageType.REMOTE:
        image = CachedNetworkImage(
            imageUrl: imageUrl ?? "",
            placeholder: (context, url) => (placeholder != null)
                ? placeholder!
                : customShimmer(height: height, width: width),
            errorWidget: (context, url, error) => Image.asset(
                  AppImages.PLACEHOLDER,
                  fit: fit ?? BoxFit.cover,
                  height: height,
                  width: height,
                ),
            fit: fit ?? BoxFit.cover,
            height: height,
            width: width);
        break;
      case ImageType.SVG_LOCAL:
        image = SvgPicture.asset(imageUrl ?? AppSvgs.SETTINGS,
            colorFilter: (color != null)
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            fit: fit ?? BoxFit.contain,
            height: height,
            width: width);
        break;
      case ImageType.SVG_REMOTE:
        image = SvgPicture.network(imageUrl ?? "",
            placeholderBuilder: (context) => (placeholder != null)
                ? placeholder!
                : customShimmer(height: height, width: width),
            errorBuilder: (context, url, error) => CustomImage(
                imageType: ImageType.SVG_LOCAL,
                fit: fit ?? BoxFit.cover,
                height: height,
                width: height),
            colorFilter: (color != null)
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            fit: fit ?? BoxFit.contain,
            height: height,
            width: width);
        break;
      case ImageType.LOTTIE_LOCAL:
        image = Lottie.asset(imageUrl ?? AppLotties.LOADING);
        break;
      case ImageType.LOTTIE_REMOTE:
        image = Lottie.asset(imageUrl ?? AppLotties.LOADING,
            fit: fit ?? BoxFit.contain, height: height, width: width);
        break;
      default:
        image = Image.asset(
          imageUrl ?? AppImages.PLACEHOLDER,
          fit: fit ?? BoxFit.cover,
          height: height,
          width: width,
        );
        break;
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: image,
    ).onTap(event: onClick);
  }
}
