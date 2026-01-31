import 'dart:developer';

import '../../../../app.dart';

class AppRoute {
  final String path;
  final Widget widget;

  const AppRoute({required this.path, required this.widget});
}

final appRoutes = [
  AppRoute(path: "/loading", widget: AlertScreen()),
  AppRoute(path: "/onboarding", widget: OnboardingScreen()),
  AppRoute(path: "/terms", widget: Terms()),
  AppRoute(path: "/privacy_policy", widget: PrivacyPolicy()),
  AppRoute(path: "/", widget: AttendanceScreen()),
  AppRoute(path: "/attendance", widget: TotalAttendanceScreen()),
  AppRoute(path: "/attendance_request", widget: AttendanceRequest()),
  AppRoute(path: "/leave", widget: LeaveScreen()),
  AppRoute(path: "/leave_request", widget: LeaveRequest()),
  AppRoute(path: "/admin_dashboard", widget: AdminDashboardScreen()),
  AppRoute(path: "/hr_dashboard", widget: HrDashboardScreen()),
  AppRoute(path: "/manager_dashboard", widget: ManagerDashboardScreen()),
  AppRoute(path: "/profile", widget: ProfileScreen()),
  AppRoute(path: "/search", widget: SearchScreens()),
  AppRoute(path: "/check_in_or_out", widget: CheckInOrOutScreen()),
];

final routesProvider = Provider<GoRouter>((ref) {
  final currentUser = ref.watch(currentUserProvider);

  log("User Active - ${currentUser.value != null}, User Loading - ${currentUser.isLoading}");
  return GoRouter(
      initialLocation: "/",
      redirect: (context, state) async {
        log("Redirect Called");
        if (currentUser.isLoading) return "/loading";
        if (currentUser.value == null) return "/onboarding";
        return null;
      },
      routes: [
        ...appRoutes.map((route) => GoRoute(
            path: route.path,
            pageBuilder: (context, state) =>
                FadeTransistionPage(child: route.widget)))
      ]);
});

class FadeTransistionPage<T> extends CustomTransitionPage<T> {
  FadeTransistionPage({required super.child})
      : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
