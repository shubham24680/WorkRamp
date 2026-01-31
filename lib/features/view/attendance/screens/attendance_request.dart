import '../../../../app.dart';

class AttendanceRequest extends StatelessWidget {
  const AttendanceRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Attendance Request"),
      body: AlertScreen()
    );
  }
}
