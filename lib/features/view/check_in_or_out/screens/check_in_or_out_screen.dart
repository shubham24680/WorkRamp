import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';
import '../../../../app.dart';

// class CheckInOrOutScreen extends StatelessWidget {
//   const CheckInOrOutScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColor.blue_1,
//         leading: CustomImage(
//           imageType: ImageType.SVG_LOCAL,
//           imageUrl: AppSvgs.ARROW_LEFT,
//           color: AppColor.white,
//           onClick: () => context.pop(),
//         ).paddingSymmetric(vertical: 8.w),
//         centerTitle: false,
//         titleSpacing: 0.0,
//         title: CustomText(
//             text: "Attendance",
//             weight: FontWeight.w600,
//             color: AppColor.white,
//             size: 18.w),
//       ),
//       body: Center(
//         child: CustomText(text: "Check In or Out"),
//       ),
//     );
//   }
// }

class CheckInOrOutScreen extends ConsumerStatefulWidget {
  const CheckInOrOutScreen({super.key});

  @override
  ConsumerState<CheckInOrOutScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInOrOutScreen> {
  Timer? _timer;
  DateTime _currentTime = DateTime.now();
  WorkType _selectedWorkType = WorkType.office;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(profileProvider).value!;
    final officeLocationAsync = ref.watch(locationProvider);
    final todayAttendanceAsync = ref.watch(todayAttendanceProvider);
    final attendanceState = ref.watch(attendanceNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.blue_1,
        leading: CustomImage(
          imageType: ImageType.SVG_LOCAL,
          imageUrl: AppSvgs.ARROW_LEFT,
          color: AppColor.white,
          onClick: () => context.pop(),
        ).paddingSymmetric(vertical: 8.w),
        title: CustomText(
            text: "Attendance",
            weight: FontWeight.w600,
            color: AppColor.white,
            size: 18.w),
      ),
      body: RefreshIndicator(
          onRefresh: () async => ref.invalidate(todayAttendanceProvider),
          child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.all(16.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomContainer(
                        padding: EdgeInsets.all(16.w),
                        gradient: [AppColor.blue_2, AppColor.blue_1],
                        borderRadius: BorderRadius.circular(25.r),
                        offset: Offset(0, 4),
                        shadowColor: Colors.black.withAlpha(100),
                        blurRadius: 8.0,
                        child: Column(children: [
                          CustomText(
                              text: DateFormat('EEEE').format(_currentTime),
                              color: Colors.white70,
                              size: 16.w),
                          CustomText(
                              text: DateFormat('MMMM dd, yyyy')
                                  .format(_currentTime),
                              color: Colors.white,
                              size: 18.w,
                              weight: FontWeight.w600),
                          SizedBox(height: 8.w),
                          CustomText(
                              text:
                                  DateFormat('hh:mm:ss a').format(_currentTime),
                              color: Colors.white,
                              size: 36.w,
                              weight: FontWeight.w600)
                        ])),
                    SizedBox(height: 16.w),

                    // Office Location Info
                    officeLocationAsync.when(
                      data: (location) {
                        return CustomContainer(
                            color: Colors.white,
                            padding: EdgeInsets.all(16.w),
                            borderRadius: BorderRadius.circular(25.r),
                            offset: Offset(0, 4),
                            shadowColor: Colors.black.withAlpha(100),
                            blurRadius: 8.0,
                            child: Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                          text: 'Assigned Office',
                                          size: 10.w,
                                          color: Colors.grey.shade700),
                                      if (user.canCheckInAnywhere)
                                        CustomChip(
                                            label: 'Any Location',
                                            backgroundColor:
                                                Colors.green.shade100,
                                            textColor: Colors.green.shade700),
                                    ]),
                                SizedBox(height: 8.w),
                                Row(children: [
                                  CustomContainer(
                                      padding: EdgeInsets.all(12.w),
                                      color: AppColor.blue_14,
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: Icon(Icons.location_on,
                                          color: AppColor.blue_3, size: 28.w)),
                                  SizedBox(width: 16.w),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        CustomText(
                                            text: location.locationName,
                                            size: 16.w,
                                            weight: FontWeight.bold),
                                        SizedBox(height: 2.w),
                                        CustomText(
                                            text: location.address,
                                            color: Colors.grey.shade700,
                                            size: 10.w,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis)
                                      ]))
                                ])
                              ],
                            ));
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    ),
                    SizedBox(height: 16.w),

                    // Work Type Selection (for check-in)
                    todayAttendanceAsync.when(
                      data: (attendance) {
                        final checkInTime = attendance?.checkInTime;
                        final checkOutTime = attendance?.checkOutTime;

                        if (checkInTime == null && user.canCheckInAnywhere) {
                          return CustomContainer(
                              color: Colors.white,
                              padding: EdgeInsets.all(16.w),
                              borderRadius: BorderRadius.circular(25.r),
                              offset: Offset(0, 4),
                              shadowColor: Colors.black.withAlpha(100),
                              blurRadius: 8.0,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                        text: 'Work Type',
                                        size: 10.w,
                                        color: Colors.grey.shade700),
                                    SizedBox(height: 8.w),
                                    Row(children: [
                                      Expanded(
                                          child: _WorkTypeButton(
                                              icon: Icons.business,
                                              label: 'Office',
                                              isSelected: _selectedWorkType ==
                                                  WorkType.office,
                                              onTap: () {
                                                setState(() {
                                                  _selectedWorkType =
                                                      WorkType.office;
                                                });
                                              })),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                          child: _WorkTypeButton(
                                              icon: Icons.home,
                                              label: 'WFH',
                                              isSelected: _selectedWorkType ==
                                                  WorkType.workFromHome,
                                              onTap: () {
                                                setState(() {
                                                  _selectedWorkType =
                                                      WorkType.workFromHome;
                                                });
                                              }))
                                    ])
                                  ]));
                        } else if (checkInTime != null &&
                            checkOutTime == null) {
                          final duration = _currentTime.difference(checkInTime);
                          final hours = duration.inHours;
                          final minutes = duration.inMinutes.remainder(60);

                          return CustomContainer(
                              color: Colors.green.shade50,
                              padding: EdgeInsets.all(16.w),
                              borderRadius: BorderRadius.circular(25.r),
                              offset: Offset(0, 4),
                              shadowColor: Colors.black.withAlpha(100),
                              blurRadius: 8.0,
                              child: Column(children: [
                                Icon(Icons.check_circle,
                                    color: Colors.green.shade700, size: 48.w),
                                SizedBox(height: 8.w),
                                CustomText(
                                    text: 'Checked In',
                                    color: Colors.green.shade700,
                                    size: 24.w,
                                    weight: FontWeight.bold),
                                CustomText(
                                  text:
                                      'at ${DateFormat('hh:mm a').format(checkInTime)}',
                                  color: Colors.green.shade700,
                                  size: 16.w,
                                ),
                                SizedBox(height: 16.w),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.timer,
                                          color: Colors.green.shade700,
                                          size: 20.w),
                                      SizedBox(width: 8.w),
                                      CustomText(
                                          text: '${hours}h ${minutes}m working',
                                          color: Colors.green.shade700,
                                          size: 18.w,
                                          weight: FontWeight.w600)
                                    ])
                              ]));
                        } else if (attendance != null &&
                            checkInTime != null &&
                            checkOutTime != null) {
                          return _buildCompletedStatus(attendance);
                        }

                        return const SizedBox.shrink();
                      },
                      loading: () => const SizedBox.shrink(),
                      error: (_, __) => const SizedBox.shrink(),
                    )
                  ]))),
      bottomNavigationBar: todayAttendanceAsync.when(
        data: (attendance) {
          if (attendance == null || attendance.checkInTime == null) {
            // Not checked in yet
            return _buildCheckButton(
                attendanceState,
                user,
                () => _handleCheckIn(user),
                Colors.green.shade700,
                Icons.fingerprint,
                'Check In',
                'Tap to mark your attendance');
          } else if (attendance.checkOutTime == null) {
            // Checked in, not checked out
            return _buildCheckButton(
                attendanceState,
                user,
                () => _handleCheckOut(attendance, user),
                Colors.red.shade700,
                Icons.logout,
                'Check Out',
                'Tap to end your shift');
          }

          return const SizedBox.shrink();
        },
        loading: () => const SizedBox.shrink(),
        error: (error, _) => const SizedBox.shrink(),
      ),
    );
  }

  Future<void> _handleCheckIn(UserModel user) async {
    await ref.read(attendanceNotifierProvider.notifier).checkIn(
          user: user,
          workType: _selectedWorkType,
        );

    if (mounted) {
      final state = ref.read(attendanceNotifierProvider);

      if (state.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomText(text: state.successMessage!),
            backgroundColor: Colors.green));

        ref.invalidate(todayAttendanceProvider);
      } else if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: CustomText(text: state.errorMessage!),
            backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _handleCheckOut(
      AttendanceModel attendance, UserModel user) async {
    await ref.read(attendanceNotifierProvider.notifier).checkOut(
          user: user,
          todayAttendance: attendance,
        );

    if (mounted) {
      final state = ref.read(attendanceNotifierProvider);

      if (state.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(text: state.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        // Refresh today's attendance
        ref.invalidate(todayAttendanceProvider);
      } else if (state.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: CustomText(text: state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildCheckButton(
      AttendanceState state,
      UserModel user,
      void Function()? onPressed,
      Color backgroundColor,
      IconData icon,
      String label,
      String hint) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      CustomButton(
          onPressed: state.isLoading ? null : onPressed,
          height: 50.w,
          backgroundColor: backgroundColor,
          child: state.isLoading
              ? CircularProgressIndicator(
                  color: backgroundColor, strokeCap: StrokeCap.round)
              : Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icon, size: 32, color: Colors.white),
                  SizedBox(width: 8.w),
                  CustomText(
                      text: label,
                      color: Colors.white,
                      size: 20.w,
                      weight: FontWeight.w600)
                ])),
      SizedBox(height: 4.w),
      CustomText(text: hint, color: Colors.grey.shade500, size: 8.w)
    ]).paddingFromLTRB(
        left: 16.w, right: 16.w, bottom: ScreenUtil().bottomBarHeight);
  }

  Widget _buildCompletedStatus(AttendanceModel attendance) {
    final checkInTime = attendance.checkInTime!;
    final checkOutTime = attendance.checkOutTime!;
    final totalHours = attendance.totalHours ?? 0;

    return CustomContainer(
        color: AppColor.blue_14,
        padding: EdgeInsets.all(16.w),
        borderRadius: BorderRadius.circular(25.r),
        offset: Offset(0, 4),
        shadowColor: Colors.black.withAlpha(100),
        blurRadius: 8.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.task_alt, color: Colors.blue.shade700, size: 64.w),
          SizedBox(height: 16.w),
          CustomText(
              text: 'Attendance Marked',
              color: AppColor.blue_1,
              size: 24.w,
              weight: FontWeight.bold),
          SizedBox(height: 16.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTimeInfo(
                'Check In',
                DateFormat('hh:mm a').format(checkInTime),
                Icons.login,
                Colors.green.shade700,
              ),
              Container(width: 1, height: 40.w, color: AppColor.blue_12),
              _buildTimeInfo(
                  'Check Out',
                  DateFormat('hh:mm a').format(checkOutTime),
                  Icons.logout,
                  Colors.red.shade700),
            ],
          ),
          SizedBox(height: 16.w),
          CustomContainer(
              padding: EdgeInsets.all(16.w),
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.access_time, color: AppColor.blue_1),
                SizedBox(width: 12.w),
                CustomText(
                    text: 'Total: ${totalHours.toStringAsFixed(1)} hours',
                    color: AppColor.blue_1,
                    size: 18.w,
                    weight: FontWeight.bold)
              ])),
          if (attendance.overtimeHours != null &&
              attendance.overtimeHours! > 0) ...[
            SizedBox(height: 8.w),
            CustomChip(
                icon: Icons.star,
                label:
                    'Overtime: ${attendance.overtimeHours!.toStringAsFixed(1)}h',
                backgroundColor: Colors.orange.shade50,
                textColor: Colors.orange.shade700)
          ]
        ]));
  }

  Widget _buildTimeInfo(String label, String time, IconData icon, Color color) {
    return Column(children: [
      Icon(icon, color: color, size: 24.w),
      SizedBox(height: 8.w),
      CustomText(text: label, color: Colors.grey.shade700, size: 10.w),
      CustomText(
        text: time,
        weight: FontWeight.bold,
      )
    ]);
  }
}

class _WorkTypeButton extends StatelessWidget {
  final IconData icon;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const _WorkTypeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        event: onTap,
        padding: EdgeInsets.all(12.w),
        color: isSelected ? AppColor.blue_14 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            Icon(icon,
                color: isSelected ? AppColor.blue_3 : Colors.grey.shade700,
                size: 28.w),
            if (label != null) ...[
              SizedBox(height: 8.w),
              CustomText(
                  text: label ?? "",
                  color: isSelected ? AppColor.blue_3 : Colors.grey.shade700,
                  weight: FontWeight.bold)
            ]
          ],
        ));
  }
}
