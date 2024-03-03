import 'package:campus_swipe/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FeeButton extends StatelessWidget {
  const FeeButton(
      {Key? key,
      required this.title,
      required this.iconData,
      required this.onPress})
      : super(key: key);
  final String title;
  final IconData iconData;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: 100.w,
        height: SizerUtil.deviceType == DeviceType.tablet ? 8.h : 7.h,
        decoration: BoxDecoration(
          borderRadius: kBottomBorderRadius,
          color: kPrimaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            Icon(
              iconData,
              color: kOtherColor,
              size: 26.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class FeeDetailRow extends StatelessWidget {
  const FeeDetailRow({Key? key, required this.title, required this.statusValue})
      : super(key: key);
  final String title;
  final String statusValue;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: kTextBlackColor,
                fontWeight: FontWeight.w900,
              ),
        ),
        Text(statusValue, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
