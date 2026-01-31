import 'package:intl/intl.dart';

import '../../../../app.dart';

class LeaveRequest extends ConsumerWidget {
  const LeaveRequest({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requestState = ref.watch(leaveRequestProvider);
    final requestNotifer = ref.watch(leaveRequestProvider.notifier);
    final dateFormat = DateFormat('yyyy-MM-dd');
    final now = DateTime.now();

    ref.listen(leaveRequestProvider, (prev, next) {
      if (!(prev?.isSuccess ?? false) && next.isSuccess) {
        customDialog(context,
            title: "Congratulations",
            subTitle: "Your leave application has been submitted successfully");
      } else if ((prev?.errorMessage == null) && (next.errorMessage != null)) {
        customDialog(context,
            icon: AppSvgs.CROSS,
            iconColor: Colors.red,
            title: "Choose another date",
            subTitle: next.errorMessage);
      }
    });

    void chooseDate(TextEditingController controller, {bool isEnd = false}) {
      final selectedDate = controller.text;
      final startDate = requestState.fromDate.text;
      final endDate = requestState.toDate.text;
      final firstDate = (isEnd && startDate.isNotEmpty)
          ? dateFormat.parse(startDate)
          : DateTime(now.year, now.month, now.day - 7);
      final lastDate = DateTime(now.year, now.month + 5, 31);
      final initialDate =
          selectedDate.isEmpty ? firstDate : dateFormat.parse(selectedDate);
      final textStyle =
          CustomText(text: "", weight: FontWeight.w900).getTextStyle();
      final child = Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            dividerTheme: DividerThemeData(color: Colors.transparent),
            colorScheme: ColorScheme.dark(
                primary: Colors.grey.shade400,
                onPrimary: Colors.grey.shade700,
                onSurface: Colors.grey.shade400),
            datePickerTheme: DatePickerThemeData(
                dayStyle: textStyle,
                weekdayStyle: textStyle,
                yearStyle: textStyle)),
        child: CalendarDatePicker(
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateChanged: (DateTime date) {
            controller.text = dateFormat.format(date);
            if (endDate.isNotEmpty &&
                dateFormat.parse(endDate).isBefore(date)) {
              requestState.toDate.text = controller.text;
            }
            requestNotifer.calculateWorkingDays();
          },
        ),
      );

      customBottomSheet(context, "Select date", child);
    }

    return Scaffold(
        appBar: customAppBar(context, title: "Leave Request"),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomTextField(
                  textFieldType: TextFieldType.DROPDOWN,
                  onChanged: (leaveType) =>
                      requestNotifer.chooseLeave(leaveType),
                  items: LeaveType.values.map((type) => type.value).toList(),
                  initialValue: requestState.leaveType.value,
                  labelText: "Leave Type",
                  floatingHintColor: AppColor.blue_1,
                  hintText: "Select",
                  suffixIcon: buildSuffixIcon(AppSvgs.ARROW_DOWN)
                      .paddingSymmetric(vertical: 8.w),
                  filled: true),
              SizedBox(height: 16.w),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: CustomTextField(
                        controller: requestState.fromDate,
                        onTap: () => chooseDate(requestState.fromDate),
                        labelText: "From",
                        floatingHintColor: AppColor.blue_1,
                        hintText: "Date",
                        errorText: requestState.fromErrorText,
                        suffixIcon: buildSuffixIcon(AppSvgs.CALENDAR),
                        filled: true,
                        readOnly: true)),
                SizedBox(width: 8.w),
                Expanded(
                    child: CustomTextField(
                        controller: requestState.toDate,
                        onTap: () =>
                            chooseDate(requestState.toDate, isEnd: true),
                        labelText: "To",
                        floatingHintColor: AppColor.blue_1,
                        hintText: "Date",
                        errorText: requestState.toErrorText,
                        suffixIcon: buildSuffixIcon(AppSvgs.CALENDAR),
                        filled: true,
                        readOnly: true)),
              ]),
              if (requestState.totalWorkingDays > 0.0) ...[
                SizedBox(height: 4.w),
                CustomText(
                    text:
                        "Total Working Days: ${requestState.totalWorkingDays}",
                    size: 10.w),
              ],
              SizedBox(height: 16.w),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(text: "Half Day", weight: FontWeight.w600),
                  Switch(
                      value: requestState.halfDay,
                      onChanged: (value) {
                        if (value) {
                          requestState.fromDate.text = dateFormat.format(now);
                          if (requestState.toDate.text.isEmpty) {
                            requestState.toDate.text =
                                requestState.fromDate.text;
                          }
                        }
                        requestNotifer.checkHalfDay(value);
                      },
                      activeColor: AppColor.blue_3,
                      activeTrackColor: AppColor.blue_14,
                      inactiveThumbColor: Colors.grey.shade700,
                      trackOutlineColor:
                          WidgetStateProperty.resolveWith((state) {
                        if (state.contains(MaterialState.selected)) {
                          return null;
                        }
                        return Colors.grey.shade700.withAlpha(40);
                      }),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap)
                ],
              ),
              SizedBox(height: 16.w),
              CustomTextField(
                  controller: requestState.reason,
                  labelText: "Reason",
                  hintText: "Write here",
                  errorText: requestState.reasonErrorText,
                  floatingHintColor: AppColor.blue_1,
                  filled: true,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline)
            ])),
        bottomNavigationBar: CustomButton(
                onPressed: requestState.isLoading
                    ? null
                    : () => requestNotifer.apply(ref),
                height: 50.w,
                backgroundColor: AppColor.blue_1,
                child: requestState.isLoading
                    ? CircularProgressIndicator(
                        color: AppColor.blue_1, strokeCap: StrokeCap.round)
                    : CustomText(
                        text: "Apply for Leave",
                        color: Colors.white,
                        size: 16.w,
                        weight: FontWeight.w600))
            .paddingFromLTRB(left: 16.w, right: 16.w, top: 16.w, bottom: 16.w));
  }

  Widget buildSuffixIcon(String imageUrl) {
    return IgnorePointer(
        child: CustomImage(
            imageType: ImageType.SVG_LOCAL,
            imageUrl: imageUrl,
            color: Colors.grey.shade700));
  }
}
