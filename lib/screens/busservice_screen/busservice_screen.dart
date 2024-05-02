import 'package:campus_swipe/constants.dart';
import 'package:campus_swipe/screens/busservice_screen/data/busservice_data.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BusServiceScreen extends StatelessWidget {
  const BusServiceScreen({Key? key}) : super(key: key);
  static const String routeName = 'BusServiceScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Service'),
      ),
      body: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: kOtherColor,
          borderRadius: kTopBorderRadius,
        ),
        child: ListView.builder(
          itemCount: busService.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                left: kDefaultPadding / 2,
                right: kDefaultPadding / 2,
              ),
              padding: EdgeInsets.all(kDefaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 3.h,
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                  Text(
                    busService[index].routeName,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: kTextBlackColor,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  if (busService[index].time.isNotEmpty)
                    Text(
                      busService[index].time,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  SizedBox(
                    height: 3.h,
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
