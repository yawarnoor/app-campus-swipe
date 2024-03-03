import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionData {
  final String date;
  final String dayName; // Added property for day name
  final String monthName;
  final String device_id;
  final String formattedTime;

  TransactionData({
    required this.dayName,
    required this.monthName,
    required this.date,
    required this.device_id,
    required this.formattedTime,
  });
}

class TransactionDataProvider {
  Future<List<TransactionData>> fetchTransactionData(String cmsId) async {
    final String apiUrl = 'http://localhost:3000/transactions/$cmsId';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<TransactionData> fetchedData = responseData
            .map((data) => TransactionData(
                  date: parseDate(data['date']),
                  device_id: data['device_id'],
                  formattedTime: formatTime(data['time']),
                  dayName: parseDayName(data['date']),
                  monthName: parseMonthName(data['date']),
                ))
            .toList();

        return fetchedData;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error during network request: $error');
      throw Exception('Network error');
    }
  }

  String parseDayName(String dateTimeString) {
    DateTime parsedDateTime = DateTime.parse(dateTimeString);
    return _getDayName(parsedDateTime.weekday);
  }

  String parseMonthName(String dateTimeString) {
    DateTime parsedDateTime = DateTime.parse(dateTimeString);
    return _getMonthName(parsedDateTime.month);
  }

  String formatTime(String timeString) {
    try {
      List<String> components = timeString.split(':');
      int hour = int.parse(components[0]);
      int minute = int.parse(
          components[1].substring(0, 2)); // Take only the first two characters
      String amPm = timeString.substring(timeString.length - 2);

      // Format the time as 'h:mm a'
      return '${_twoDigits(hour)}:${_twoDigits(minute)} $amPm';
    } catch (e) {
      // Handle the case where the time format is not as expected
      print('Error parsing time: $e');
      return ''; // or handle accordingly based on your requirements
    }
  }

  String parseDate(String dateTimeString) {
    // Parse the input date string into a DateTime object
    DateTime parsedDateTime = DateTime.parse(dateTimeString);

    // Format the DateTime object as a string in 'yyyy-MM-dd' format
    return '${parsedDateTime.year}-${_twoDigits(parsedDateTime.month)}-${_twoDigits(parsedDateTime.day)}';
  }

  String _twoDigits(int n) {
    // Helper function to add leading zero for single-digit numbers
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }

  String _getDayName(int dayOfWeek) {
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }
}
