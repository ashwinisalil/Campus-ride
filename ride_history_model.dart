class RideHistoryModel {
  final String id;
  final String date;
  final String time;
  final String route;
  final String distance;
  final String busNumber;
  final String attendanceStatus; // Verified, Missed, Pending

  RideHistoryModel({
    required this.id,
    required this.date,
    required this.time,
    required this.route,
    required this.distance,
    required this.busNumber,
    required this.attendanceStatus,
  });

  factory RideHistoryModel.fromMap(Map<String, dynamic> map, String id) {
    return RideHistoryModel(
      id: id,
      date: map['date'] ?? 'Today',
      time: map['time'] ?? '08:15 AM',
      route: map['route'] ?? 'Route A (City Hub)',
      distance: map['distance'] ?? '12.4 km',
      busNumber: map['busNumber'] ?? 'Bus #04',
      attendanceStatus: map['attendanceStatus'] ?? 'Verified',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'route': route,
      'distance': distance,
      'busNumber': busNumber,
      'attendanceStatus': attendanceStatus,
    };
  }
}
