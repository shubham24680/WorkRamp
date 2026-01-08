import '../../app.dart';

enum TextFieldType { INPUT, DROPDOWN }

typedef OnChanged = void Function(String?)?;
typedef OnTap = void Function()?;
typedef Validator = String? Function(String?)?;

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      this.textFieldType = TextFieldType.INPUT,
      this.controller,
      this.filled,
      this.fillColor,
      this.labelText,
      this.hintText,
      this.hintColor,
      this.errorText,
      this.floatingHintColor,
      this.errorColor,
      this.keyboardType,
      this.items = const [],
      this.onChanged,
      this.readOnly = false,
      this.autofocus = false,
      this.onTap,
      this.initialValue,
      this.perfixIcon,
      this.suffixIcon,
      this.obscureText = false,
      this.validator});

  final TextFieldType textFieldType;
  final TextEditingController? controller;
  final bool? filled;
  final bool readOnly;
  final bool autofocus;
  final Color? fillColor;
  final Color? hintColor;
  final Color? floatingHintColor;
  final Color? errorColor;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final String? initialValue;
  final List<String> items;
  final TextInputType? keyboardType;
  final Widget? perfixIcon;
  final Widget? suffixIcon;
  final OnChanged onChanged;
  final OnTap onTap;
  final bool obscureText;
  final Validator validator;

  @override
  Widget build(BuildContext context) {
    final defaultColor = Colors.grey.shade700.withAlpha(40);

    final decoration = InputDecoration(
        filled: filled,
        fillColor: fillColor ?? Colors.grey.shade700.withAlpha(20),
        labelText: labelText,
        hintText: hintText,
        errorText: errorText,
        labelStyle: buildHint(hintColor).getTextStyle(),
        floatingLabelStyle: buildHint(floatingHintColor).getTextStyle(),
        hintStyle: buildHint(hintColor).getTextStyle(),
        errorStyle: buildHint(Colors.red.shade700, size: 10.w).getTextStyle(),
        prefixIcon: perfixIcon?.paddingAll(0.01.sh),
        suffixIcon: suffixIcon?.paddingAll(0.01.sh) ?? const SizedBox.shrink(),
        focusedErrorBorder: buildBorder(Colors.red.shade700),
        errorBorder: buildBorder(Colors.red.shade700),
        focusedBorder: buildBorder(AppColor.blue_1),
        enabledBorder: buildBorder(defaultColor),
        disabledBorder: buildBorder(defaultColor));

    final dropDownMenu = items
        .map((value) => DropdownMenuItem(
            value: value, child: buildHint(AppColor.white, text: value)))
        .toList();

    Widget field;
    switch (textFieldType) {
      case TextFieldType.DROPDOWN:
        field = DropdownButtonFormField(
            items: dropDownMenu,
            value: initialValue,
            onChanged: onChanged,
            decoration: decoration.copyWith(suffixIcon: suffixIcon),
            style: buildHint(AppColor.white).getTextStyle(),
            hint: buildHint(hintColor, text: hintText),
            dropdownColor: AppColor.blue_1,
            borderRadius: BorderRadius.circular(0.015.sh));
        break;
      default:
        field = TextFormField(
          decoration: decoration,
          controller: controller,
          onTap: onTap,
          onChanged: onChanged,
          readOnly: readOnly,
          autofocus: autofocus,
          obscureText: obscureText,
          keyboardType: keyboardType ?? TextInputType.text,
          style: buildHint(AppColor.black3).getTextStyle(),
          cursorColor: AppColor.blue_1,
          cursorErrorColor: Colors.red.shade700,
          validator: validator,
        );
        break;
    }

    return field;
  }

  CustomText buildHint(Color? color,
      {String? text, FontWeight weight = FontWeight.w600, double? size}) {
    return CustomText(
        text: text ?? "",
        color: color ?? Colors.grey.shade700.withAlpha(40),
        size: size,
        weight: weight);
  }

  InputBorder buildBorder(Color color) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color),
      borderRadius: BorderRadius.circular(12.r),
    );
  }
}
