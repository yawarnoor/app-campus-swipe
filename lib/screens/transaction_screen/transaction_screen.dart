import 'package:campus_swipe/constants.dart';
import 'package:campus_swipe/screens/transaction_screen/data/transaction_data.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key, required this.cms_id}) : super(key: key);
  static const String routeName = 'TransactionScreen';
  final String cms_id;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<TransactionData> transactions = [];
  final TransactionDataProvider dataProvider = TransactionDataProvider();

  @override
  void initState() {
    super.initState();
    // Fetch transaction data using widget.cmsId
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    try {
      List<TransactionData> fetchedData =
          await dataProvider.fetchTransactionData(widget.cms_id);

      setState(() {
        transactions = fetchedData;
      });
    } catch (error) {
      // Handle errors here
      print('Error fetching transaction data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: Container(
        width: 100.w,
        decoration: BoxDecoration(
          color: kOtherColor,
          borderRadius: kTopBorderRadius,
        ),
        child: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  left: kDefaultPadding / 2, right: kDefaultPadding / 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),
                  //first need a row, then 3 columns
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //1st column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            transactions[index].date.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: kTextBlackColor,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          Text(
                            transactions[index].monthName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      //2nd one
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            transactions[index].device_id,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  color: kTextBlackColor,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          Text(
                            transactions[index].dayName,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                      //3rd one
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '🕒${transactions[index].formattedTime}',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(
                                    color: kTextBlackColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
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
