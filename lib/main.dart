import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: ApiConstants.URL, anonKey: ApiConstants.ANON_KEY);
  runApp(ProviderScope(
      observers: [CustomProviderObservers()], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider);

    return ScreenUtilInit(
        child: MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: light,
      routerConfig: routes,
    ));
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
//         ChangeNotifierProvider(create: (context) => TaskProvider()),
//         ChangeNotifierProvider(create: (context) => SettingsProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         routes: routes,
//         theme: light,
//         // darkTheme: dark,
//         home: AttendanceScreen(),
//         // home: Profile(),
//       ),
//     );
//   }
// }
