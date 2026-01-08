import 'package:intl/intl.dart';
import '../../../../app.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [_buildTopWidget(context), _buildMainContent()],
    ));
  }

  Widget _buildTopWidget(BuildContext context) {
    return SizedBox(
      height: 330.w,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          AttendanceAppBar(),
          AttendanceAvgTime(),
          _buildCheckout(context),
        ],
      ),
    );
  }

  Widget _buildCheckout(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final todayAttendanceAsync = ref.watch(todayAttendanceProvider);

      return todayAttendanceAsync.when(
          data: (attendance) {
            final checkIn = attendance?.checkInTime;
            final checkOut = attendance?.checkOutTime;
            Color backgroundColor;
            String text;

            if (checkIn == null) {
              backgroundColor = Colors.green.shade700;
              text = "Check In";
            } else if (checkOut == null) {
              backgroundColor = Colors.red.shade700;
              text = "Check Out";
            } else {
              backgroundColor = AppColor.blue_1;
              text = "Attendance Marked";
            }

            return CustomButton(
              buttonNature: ButtonNature.BOUNDED,
              backgroundColor: backgroundColor,
              borderRadius: 12.r,
              height: 50.w,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                CustomImage(
                    imageType: ImageType.SVG_LOCAL,
                    imageUrl: AppSvgs.CLOCK,
                    color: AppColor.white,
                    height: 16.w),
                SizedBox(width: 8.w),
                CustomText(
                    text: text, color: AppColor.white, weight: FontWeight.w600)
              ]),
              onPressed: () => context.push("/check_in_or_out"));
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink());
    });
  }

  Widget _buildMainContent() {
    return Container(
      color: Colors.white,
      height: 1.sh,
    );
  }
}
