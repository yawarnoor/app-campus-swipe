class PackageData {
  final String duration;
  final String totalAmount;
  final String btnStatus;

  PackageData(this.duration, this.totalAmount, this.btnStatus);
}

List<PackageData> Package = [
  PackageData('7 Days', 'PKR 700', 'Subscribe'),
  PackageData('15 Days', 'PKR 1500', 'Subscribe'),
  PackageData('30 Days', 'PKR 3000', 'Subscribe'),
];
