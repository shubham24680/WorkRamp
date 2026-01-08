import '../../../../app.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);


    return Scaffold(
        body: profileState.when(
            data: (userData) => ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  children: [
                    _buildAppBar(context, userData),
                    _buildProfile(context, ref, userData)
                  ],
                ),
            error: (error, stackTrace) =>
                Center(child: CustomText(text: "Something went wrong")),
            loading: () => Center(
                child: CircularProgressIndicator(
                    color: AppColor.blue_1, strokeCap: StrokeCap.round))));
  }

  Widget _buildAppBar(BuildContext context, UserModel userData) {
    final topPadding = ScreenUtil().statusBarHeight + 8.w;

    return CustomContainer(
        color: AppColor.blue_1,
        padding: EdgeInsets.only(
            left: 16.w, right: 16.w, top: topPadding, bottom: 16.w),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25.r)),
        child: Column(children: [
          Row(
            children: [
              CustomButton(
                  buttonType: ButtonType.ICON,
                  icon: AppSvgs.ARROW_LEFT,
                  onPressed: () => context.pop()),
              const Spacer(),
              // CustomButton(
              //     buttonType: ButtonType.ICON,
              //     icon: AppSvgs.SETTINGS,
              //     onPressed: () {})
            ],
          ),
          CustomImage(
              imageType: ImageType.SVG_LOCAL,
              imageUrl: AppSvgs.AVATAR,
              height: 72.w,
              width: 72.w,
              borderRadius: BorderRadius.circular(1.sw),
              onClick: () {}),
          // SizedBox(height: 8.w),
          // CustomChip(
          //     label: "On Probation", backgroundColor: Colors.yellow.shade700),
          SizedBox(height: 8.w),
          CustomText(
              text: userData.name,
              color: AppColor.white,
              weight: FontWeight.w700,
              overflow: TextOverflow.ellipsis),
          CustomText(
              text:
                  "${userData.designation}, ${userData.department.name.toUpperCase()}",
              color: AppColor.white,
              size: 12.w,
              overflow: TextOverflow.ellipsis),
        ]));
  }

  Widget _buildProfile(BuildContext context, WidgetRef ref, UserModel userData) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    final location = ref.watch(locationProvider).value?.address;
    final phone = userData.phone;
    Map<String, String> data = {
      "Employee ID": userData.employeeId,
      "Email ID": userData.email,
      "Department": userData.department.name.toUpperCase(),
      if(location != null) "Current Office Location": location,
      if(phone != null) "Office Mobile Number": phone
    };

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CustomText(text: "Profile Details", weight: FontWeight.w600, size: 16.w),
      SizedBox(height: 8.w),
      ...data.entries.map((d) => _buildInformation(d)),
      SizedBox(height: 16.w),
      // Row(children: [
      //   Flexible(
      //       child: CustomButton(
      //           backgroundColor: AppColor.blue_1,
      //           borderRadius: 12.r,
      //           height: 50.w,
      //           child: CustomText(
      //               text: "Personal Details",
      //               color: AppColor.white,
      //               weight: FontWeight.w600),
      //           onPressed: () {})),
      //   SizedBox(width: 4.w),
      //   Flexible(
      //       child: CustomButton(
      //           backgroundColor: AppColor.blue_1,
      //           borderRadius: 12.r,
      //           height: 50.w,
      //           child: CustomText(
      //               text: "Separation",
      //               color: AppColor.white,
      //               weight: FontWeight.w600),
      //           onPressed: () {})),
      // ]),
      // SizedBox(height: 4.w),
      CustomButton(
        backgroundColor: Colors.red.shade700,
        borderRadius: 12.r,
        height: 50.w,
        onPressed: authState.isLoading
            ? null
            : () async {
                await authNotifier.signOut();
                ref.read(keyProvider.notifier).state++;
                if (context.mounted && authState.user.user == null) {
                  context.go("/");
                }
              },
        child: authState.isLoading
            ? CircularProgressIndicator(
                color: Colors.red.shade700, strokeCap: StrokeCap.round)
            : CustomText(
                text: "Sign out",
                color: AppColor.white,
                weight: FontWeight.w600),
      )
    ]).paddingAll(16.w);
  }

  Widget _buildInformation(MapEntry<String, String> data) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              text: data.key,
              weight: FontWeight.w500,
              size: 10.w,
              color: Colors.grey.shade700),
          CustomText(text: data.value, weight: FontWeight.w500, size: 12.w),
          SizedBox(height: 12.w),
        ]);
  }
}

// class Profile extends StatelessWidget {
//   Profile({super.key});
//
//   final User? _user = Supabase.instance.client.auth.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     final taskProv = Provider.of<TaskProvider>(context, listen: false);
//     final settingProv = Provider.of<SettingsProvider>(context, listen: false);
//
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.only(bottom: 100),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 height: 350,
//                 width: double.infinity,
//                 color: lightGrey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Profile Pic
//                     Container(
//                       height: 120,
//                       width: 120,
//                       decoration: BoxDecoration(
//                         color: black,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: white, width: 5),
//                       ),
//                       child: GestureDetector(
//                         onTap: () =>
//                             Navigator.pushNamed(context, "/changeAvatar"),
//                         child: Consumer<SettingsProvider>(
//                           builder: (_, provider, __) =>
//                               SvgPicture.asset(provider.selectedAvatar),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     // Name
//                     Inter(
//                       text: _user?.userMetadata?["full_name"] ?? "...",
//                       textAlign: TextAlign.center,
//                       weight: FontWeight.bold,
//                       size: 20,
//                     ),
//                     // Email Address
//                     Inter(
//                       text: _user?.email ?? "...",
//                       size: 12,
//                     ),
//                   ],
//                 ),
//               ),
//
//               // Logout button
//               ElevatedButton(
//                 onPressed: () async {
//                   await GoogleService.signOut(context);
//                   taskProv.clearTask();
//                   settingProv.clearSetting();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   foregroundColor: black,
//                 ),
//                 child: Inter(
//                   text: "Log Out",
//                   color: Colors.red,
//                   weight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         extendBodyBehindAppBar: true,
//       ),
//     );
//   }
// }
