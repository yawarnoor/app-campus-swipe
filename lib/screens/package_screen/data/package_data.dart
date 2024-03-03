class PackageData {
  final String duration;
  final String totalAmount;
  final String btnStatus;

  PackageData(this.duration, this.totalAmount, this.btnStatus);
}

List<PackageData> Package = [
  PackageData('7 Days', '100\$', 'Subscribe'),
  PackageData('15 Days', '200\$', 'Subscribe'),
  PackageData('30 Days', '350\$', 'Subscribe'),
];
