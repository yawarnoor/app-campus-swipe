import 'package:campus_swipe/constants.dart';
import 'package:flutter/material.dart';
import 'data/package_data.dart';
import 'widgets/package_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PackageScreen extends StatefulWidget {
  const PackageScreen({Key? key, required this.prefs}) : super(key: key);
  static String routeName = 'PackageScreen';

  final SharedPreferences prefs;

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Package'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: kTopBorderRadius,
                color: kOtherColor,
              ),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(kDefaultPadding),
                  itemCount: Package.length,
                  itemBuilder: (context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: kDefaultPadding),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(kDefaultPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(kDefaultPadding),
                              ),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: kTextLightColor,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                sizedBox,
                                PackageDetailRow(
                                  title: 'Duration',
                                  statusValue: Package[index].duration,
                                ),
                                sizedBox,
                                SizedBox(
                                  height: kDefaultPadding,
                                  child: Divider(
                                    thickness: 1.0,
                                  ),
                                ),
                                PackageDetailRow(
                                  title: 'Total Amount',
                                  statusValue: Package[index].totalAmount,
                                ),
                              ],
                            ),
                          ),
                          PackageButton(
                            title: Package[index].btnStatus,
                            iconData: Package[index].btnStatus == 'Paid'
                                ? Icons.download_outlined
                                : Icons.arrow_forward_outlined,
                            onPress: () {
                              // Show confirmation dialog
                              showConfirmationDialog(context, Package[index]);
                            },
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  void showConfirmationDialog(BuildContext context, PackageData package) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Subscription'),
          content: Text('Are you sure you want to subscribe to this package?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);

                if (!mounted) return; // Close the dialog

                // Make a request to the API to generate the PDF invoice
                final response = await http.post(
                  Uri.parse('https://invoice-generator.com/'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    "to":
                        "${widget.prefs.getString('first_name')} ${widget.prefs.getString('last_name')}",
                    "from": "Campus Swipe",
                    "currency": "PKR",
                    "logo":
                        "https://i.ibb.co/hZPt364/Campus-Swipe-1-removebg-preview.png",
                    "items": [
                      {
                        "name": "Bus Access Subscription (7 days) ",
                        "unit_cost": 500,
                        "description":
                            "You will gain access to transportation services for a duration of 7 days."
                      }
                    ],
                    "custom_fields": [
                      {
                        "name": "Student ID",
                        "value": "${widget.prefs.getString('cms_id')}"
                      }
                    ],
                    "notes":
                        "This invoice has been generated electronically and is considered valid without the need for a physical signature.",
                    "terms":
                        "This invoice is valid for a period of 24 hours from the date of issuance. \n The issuer reserves the right to cancel the invoice if payment is not received within the stipulated 24-hour period. ",
                    "ship_to_title": "Email:",
                    "ship_to": "${widget.prefs.getString('email')}"
                  }),
                );

                if (response.statusCode == 200) {
                  final pdfBytes = response.bodyBytes;

                  // Convert PDF bytes to a base64-encoded string
                  final pdfBase64 = base64Encode(pdfBytes);

                  final emailResponse = await http.post(
                    Uri.parse('http://127.0.0.1:3000/sendEmail'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'userEmail': '${widget.prefs.getString('email')}',
                      'pdfBase64': pdfBase64,
                    }),
                  );

                  print(
                      'Email Response Status Code: ${emailResponse.statusCode}');
                  print('Email Response Body: ${emailResponse.body}');

                  if (emailResponse.statusCode == 200) {
                    print('Email sent successfully');
                    // Show a success message (optional)
                    final materialAppState =
                        context.findAncestorStateOfType<_PackageScreenState>();
                    if (materialAppState != null && materialAppState.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Email sent successfully')),
                      );
                    }

                    // Show another dialog for successful email sent
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: Text('Email sent successfully!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    print(
                        'Failed to send email. Status code: ${emailResponse.statusCode}');
                    // Handle failure, e.g., show an error message
                  }
                } else {
                  print(
                      'Failed to generate PDF. Status code: ${response.statusCode}');
                  // Handle failure, e.g., show an error message
                }
              },
              child: Text('Subscribe'),
            ),
          ],
        );
      },
    );
  }
}
