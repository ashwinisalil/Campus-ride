class BusModel {
  final String id;
  final String busNumber;
  final String routeId;
  final String driverName;
  final String driverPhone;
  final int capacity;
  final int currentOccupancy;
  final double currentSpeed;
  final double latitude;
  final double longitude;
  final bool isRunning;
  final String estimatedArrival;
  final String nextStop;

  BusModel({
    required this.id,
    required this.busNumber,
    required this.routeId,
    required this.driverName,
    required this.driverPhone,
    required this.capacity,
    required this.currentOccupancy,
    required this.currentSpeed,
    required this.latitude,
    required this.longitude,
    required this.isRunning,
    required this.estimatedArrival,
    required this.nextStop,
  });

  factory BusModel.fromMap(Map<String, dynamic> map, String id) {
    return BusModel(
      id: id,
      busNumber: map['busNumber'] ?? 'Bus #04',
      routeId: map['routeId'] ?? 'Route A',
      driverName: map['driverName'] ?? 'Rajesh Sharma',
      driverPhone: map['driverPhone'] ?? '+91 98765 43211',
      capacity: map['capacity'] ?? 45,
      currentOccupancy: map['currentOccupancy'] ?? 28,
      currentSpeed: (map['currentSpeed'] ?? 38.5).toDouble(),
      latitude: (map['latitude'] ?? 18.5204).toDouble(),
      longitude: (map['longitude'] ?? 73.8567).toDouble(),
      isRunning: map['isRunning'] ?? true,
      estimatedArrival: map['estimatedArrival'] ?? '7 Mins',
      nextStop: map['nextStop'] ?? 'North Campus Gate',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'busNumber': busNumber,
      'routeId': routeId,
      'driverName': driverName,
      'driverPhone': driverPhone,
      'capacity': capacity,
      'currentOccupancy': currentOccupancy,
      'currentSpeed': currentSpeed,
      'latitude': latitude,
      'longitude': longitude,
      'isRunning': isRunning,
      'estimatedArrival': estimatedArrival,
      'nextStop': nextStop,
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }
}
