class DataSheet {
  final int date;
  final String monthName;
  final String subjectName;
  final String dayName;
  final String time;

  DataSheet(
      this.date, this.monthName, this.subjectName, this.dayName, this.time);
}

List<DataSheet> dateSheet = [
  DataSheet(11, 'JAN', 'Technological Entrepreneurship', 'Monday', '9:00am'),
  DataSheet(12, 'JAN', 'Enterprise Application Devel', 'Tuesday', '10:00am'),
  DataSheet(13, 'JAN', 'Calculus', 'Wednesday', '9:30am'),
  DataSheet(14, 'JAN', 'Graph Theory', 'Thursday', '11:00am'),
  DataSheet(15, 'JAN', 'FYP-I', 'Friday', '9:00am'),
  DataSheet(16, 'JAN', 'Compiler Construction', 'Saturday', '11:00am'),
];
