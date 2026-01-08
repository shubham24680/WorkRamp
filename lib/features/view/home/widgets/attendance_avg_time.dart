import 'package:intl/intl.dart';

import '../../../../app.dart';

class AttendanceAvgTime extends ConsumerWidget {
  const AttendanceAvgTime({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final address = ref.watch(locationProvider).value?.address;
    final times = DateFormat("hh : mm : ss").format(DateTime.now()).split(" ");

    return CustomContainer(
      color: AppColor.white,
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 20.w),
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w, bottom: 30.w),
      borderRadius: BorderRadius.circular(25.r),
      offset: Offset(0, 8),
      shadowColor: Colors.black.withAlpha(100),
      blurRadius: 10.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(text: "Average Working Time", weight: FontWeight.w500),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildTime(times)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomImage(
                  imageType: ImageType.SVG_LOCAL,
                  imageUrl: AppSvgs.LOCATION,
                  height: 12.w),
              SizedBox(width: 4.w),
              if (address != null)
                Flexible(
                    child: CustomText(
                        text: address,
                        size: 10.w,
                        overflow: TextOverflow.ellipsis))
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildTime(List<String> times) {
    return List.generate(times.length, (index) {
      if (index % 2 == 0) {
        return CustomContainer(
          padding: EdgeInsets.all(8.w),
          margin: EdgeInsets.all(8.w),
          color: Colors.grey.withAlpha(100),
          borderRadius: BorderRadius.circular(12.r),
          child: CustomText(
              text: times[index], size: 32.w, weight: FontWeight.w600),
        );
      }
      return CustomText(text: times[index], size: 32.w);
    });
  }
}
