import '../../../../app.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(context, title: "Dashboard"),
        body: Center(child: CustomText(text: "Dashboard")));
  }
}
