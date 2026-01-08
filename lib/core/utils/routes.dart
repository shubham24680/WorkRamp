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
  AppRoute(path: "/", widget: Home()),
  AppRoute(path: "/profile", widget: ProfileScreen()),
  AppRoute(path: "/search", widget: SearchScreens()),
  AppRoute(path: "/check_in_or_out", widget: CheckInOrOutScreen()),
];

final keyProvider = StateProvider<int>((ref) => 0);
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

// final Map<String, Widget Function(BuildContext)> routes = {
//   '/onboarding': (_) => Onboarding(),
//   '/termsOfServices': (_) => Terms(),
//   '/privacyPolicy': (_) => PrivacyPolicy(),
//   '/home': (_) => Home(),
//   '/edit': (_) => const Edit(),
//   '/profile': (_) => Profile(),
//   '/changeAvatar': (_) => ChangeAvatar(),
// };
