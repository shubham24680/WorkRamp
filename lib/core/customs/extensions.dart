import '../../app.dart';

extension PaddingExtension on Widget {
  Padding paddingFromLTRB(
      {double left = 0,
        double top = 0,
        double right = 0,
        double bottom = 0}) =>
      Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: this,
      );

  Padding paddingAll(double value) =>
      paddingFromLTRB(left: value, top: value, right: value, bottom: value);

  Padding paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      paddingFromLTRB(
          left: horizontal, right: horizontal, top: vertical, bottom: vertical);
}

extension ClickExtension on Widget {
  Widget _gestureDetector({void Function()? onTap}) => GestureDetector(
    onTap: onTap ?? () {},
    child: this,
  );

  Widget onTap({void Function()? event}) => _gestureDetector(onTap: event);
}