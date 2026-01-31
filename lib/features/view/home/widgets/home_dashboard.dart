import '../../../../app.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(profileProvider);

    Widget? child;
    String? path;
    child = currentUser.when(
        data: (user) {
          switch (user.role) {
            case UserRole.admin:
              path = "/admin_dashboard";
              return _adminDashBoard();
            case UserRole.hr:
              path = "/hr_dashboard";
              return _hrDashBoard();
            case UserRole.manager:
              path = "/manager_dashboard";
              return _managerDashBoard();
            default:
              return null;
          }
        },
        error: (_, __) => null,
        loading: () => null);

    if (child == null || path == null) return const SizedBox.shrink();
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildTitle("Dashboard", event: () => context.push(path ?? "")),
          CustomContainer(
              color: Colors.white,
              margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.w),
              padding: EdgeInsets.symmetric(vertical: 4.w),
              borderRadius: BorderRadius.circular(25.r),
              shadowColor: Colors.black.withAlpha(25),
              blurRadius: 10.0,
              child: child)
        ]);
  }

  Widget _adminDashBoard() {
    return Center(child: CustomText(text: "Admin DashBoard"));
  }

  Widget _hrDashBoard() {
    return Center(child: CustomText(text: "HR DashBoard"));
  }

  Widget _managerDashBoard() {
    return Center(child: CustomText(text: "Manager DashBoard"));
  }
}
