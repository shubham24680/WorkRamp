import '../../../../app.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: "Dashboard"),
      body: Center(child: CustomText(text: "Manager Dashboard")),
    );
  }
}
