import '../../app.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({super.key, this.label = "", this.backgroundColor, this.textColor, this.icon});

  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8.r),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(icon != null) Icon(icon, color: textColor, size: 8.w),
          if(icon != null && label.isNotEmpty) SizedBox(width: 4.w),
          if(label.isNotEmpty) CustomText(text: label, size: 8.w, weight: FontWeight.bold, color: textColor),
        ],
      ),
    );
  }
}
