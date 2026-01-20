import '../../../../app.dart';

class TotalAttendanceScreen extends StatelessWidget {
  const TotalAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: "Total Attendance"),
        body: Center(child: CustomText(text: "Total Attendance")));
  }
}
