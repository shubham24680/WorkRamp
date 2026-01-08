import '../../../app.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(profileProvider);

    return currentUser.when(
        data: (user) {
          switch (user.role) {
            case UserRole.admin:
              return const DashboardScreen();
            case UserRole.hr:
              return const DashboardScreen();
            case UserRole.manager:
              return const DashboardScreen();
            default:
              return const AttendanceScreen();
          }
        },
        error: (error, stackTrace) => AlertScreen(type: ScreenType.VERIFY),
        loading: () => AlertScreen());
  }
}

// class Home extends StatelessWidget {
//   Home({super.key});
//
//   final String now = DateFormat("dd EEE").format(DateTime.now());
//
//   @override
//   Widget build(BuildContext context) {
//     final taskProv = Provider.of<TaskProvider>(context, listen: false);
//     final settingProv = Provider.of<SettingsProvider>(context);
//     final user = Supabase.instance.client.auth.currentUser;
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: homeAppBar(context, now, settingProv.selectedAvatar),
//         body: Consumer<ConnectivityProvider>(
//           builder: (_, connectivityProvider, __) {
//             SchedulerBinding.instance.addPostFrameCallback((_) async {
//               if (!connectivityProvider.isOffline &&
//                   !settingProv.isFetch &&
//                   user != null) {
//                 taskProv.fetchTask();
//                 settingProv.fetchAvatar();
//               }
//             });
//             return connectivityProvider.isOffline
//                 ? NoConnection()
//                 : Consumer<TaskProvider>(
//                     builder: (_, taskProvider, __) {
//                       final card = taskProvider.allTasks;
//                       if (taskProvider.isLoading) {
//                         return Center(
//                           child: CircularProgressIndicator(color: black),
//                         );
//                       } else if (card.isEmpty) {
//                         return Center(
//                           child: Inter(
//                             text: "Kickstart your productivity...",
//                             size: 12,
//                             weight: FontWeight.normal,
//                           ),
//                         );
//                       } else {
//                         return CardList(card: card);
//                       }
//                     },
//                   );
//           },
//         ),
//         floatingActionButton: floatingButton(context),
//       ),
//     );
//   }
// }
