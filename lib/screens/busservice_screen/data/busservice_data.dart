class BusService {
  final String routeName;
  final String time;

  BusService(this.routeName, this.time);
}

List<BusService> busService = [
  // Morning Shift
  BusService('Pick Students Regular Morning Shift', ''),
  BusService('Rohri', '08:00.am'),
  BusService('Navy Park', '08:05.am'),
  BusService('Old Sukkur', '08:10.am'),
  BusService('Shalimar', '08:12.am'),
  BusService('Local Board', '08:13.am'),
  BusService('Dolphin Bakers', '08:14.am'),
  BusService('Ayub Gate', '08:15.am'),
  BusService('Gurdwara Chowk', '08:17.am'),
  BusService('Police Line', '08:19.am'),
  BusService('Railway Officer club', '08:20.am'),
  BusService('Garam Godi', '08:22.am'),
  BusService('Sibau', '08:30.am'),
  BusService('Dolphin Bakers Military Road', '08:23.am'),

  // Evening Shift
  BusService('Pick Students Regular Evening Shift', ''),
  BusService('Rohri', '11:00.am'),
  BusService('Navy Park', '11:05.am'),
  BusService('Old Sukkur', '11:10.am'),
  BusService('Shalimar', '11:12.am'),
  BusService('Local Board', '11:13.am'),
  BusService('Dolphin Bakers', '11:14.am'),
  BusService('Ayub Gate', '11:15.am'),
  BusService('Gurdwara Chowk', '11:17.am'),
  BusService('Police Line', '11:19.am'),
  BusService('Railway Officer club', '11:20.am'),
  BusService('Garam Godi', '11:22.am'),
  BusService('City Point', '11:25.am'),
  BusService('Township', '11:27.am'),

  BusService('Drop Students Morning Shift City & Hostels', '02:00.pm'),
  BusService('Drop Students Evening Shift City & Hostels', '05:15.pm'),

  BusService('Pick Employee Old Sukkur', '08:25.am'),
  BusService('Staff Hostel Society', '08:45.am'),
];
