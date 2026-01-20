import '../../../../app.dart';

class HrDashboardScreen extends StatelessWidget {
  const HrDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Dashboard"),
      body: Center(child: CustomText(text: "HR Dashboard")),
    );
  }
}
