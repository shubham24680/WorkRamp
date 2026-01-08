import 'dart:developer';

import '../../app.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          log("Waiting");
          return AlertScreen();
        } else if (snapshot.hasError) {
          log("NoConnection");
          return AlertScreen();
        } else if (snapshot.hasData && snapshot.data!.session != null) {
          log("Home");
          return Home();
        } else {
          log("Onboarding");
          return OnboardingScreen();
        }
      },
    );
  }
}
