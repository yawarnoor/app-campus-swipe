import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:campus_swipe/constants.dart';
import 'package:campus_swipe/screens/transaction_screen/data/transaction_data.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({Key? key, required this.cms_id}) : super(key: key);
  static const String routeName = 'TransactionScreen';
  final String cms_id;

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<TransactionData> transactions = [];
  List<TransactionData> filteredTransactions = [];
  final TransactionDataProvider dataProvider = TransactionDataProvider();
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  Future<void> fetchTransactionData() async {
    try {
      List<TransactionData> fetchedData =
          await dataProvider.fetchTransactionData(widget.cms_id);
      setState(() {
        transactions = fetchedData;
        filteredTransactions = fetchedData;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching transaction data: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void filterTransactions(String query) {
    String lowerCaseQuery = query.toLowerCase();
    List<TransactionData> dummySearchList = [];
    dummySearchList.addAll(transactions);

    if (query.isNotEmpty) {
      List<TransactionData> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.date.toLowerCase().contains(lowerCaseQuery) ||
            item.device_id.toLowerCase().contains(lowerCaseQuery)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredTransactions = dummyListData;
      });
      return;
    } else {
      setState(() {
        filteredTransactions = transactions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Enter date or device ID",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                    onChanged: (value) {
                      filterTransactions(value);
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 100.w,
                    decoration: BoxDecoration(
                      color: kOtherColor,
                      borderRadius: kTopBorderRadius,
                    ),
                    child: ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        return buildTransactionItem(context, index);
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildTransactionItem(BuildContext context, int index) {
    var transaction = filteredTransactions[index];
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.date,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: kTextBlackColor,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    transaction.monthName,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: kTextBlackColor, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.device_id,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: kTextBlackColor,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  Text(
                    transaction.dayName,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: kTextBlackColor, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🕒${transaction.formattedTime}',
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: kTextBlackColor, fontWeight: FontWeight.bold),
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
  }
}
