import 'package:campus_swipe/constants.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AssignmentDetailRow extends StatelessWidget {
  const AssignmentDetailRow(
      {Key? key, required this.title, required this.statusValue})
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
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: kTextBlackColor, fontWeight: FontWeight.w900),
        ),
        Text(
          statusValue,
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: kTextBlackColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class AssignmentButton extends StatelessWidget {
  const AssignmentButton({Key? key, required this.title, required this.onPress})
      : super(key: key);
  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: 100.w,
        height: 7.h,
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(kDefaultPadding),
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: kTextLightColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
