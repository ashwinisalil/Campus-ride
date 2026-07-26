class RouteModel {
  final String id;
  final String routeName;
  final String startPoint;
  final String endPoint;
  final String totalDistance;
  final String duration;
  final List<String> stops;

  RouteModel({
    required this.id,
    required this.routeName,
    required this.startPoint,
    required this.endPoint,
    required this.totalDistance,
    required this.duration,
    required this.stops,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map, String id) {
    return RouteModel(
      id: id,
      routeName: map['routeName'] ?? 'Route A - City Hub to Main Gate',
      startPoint: map['startPoint'] ?? 'City Central Station',
      endPoint: map['endPoint'] ?? 'Engineering Campus Block B',
      totalDistance: map['totalDistance'] ?? '14.2 km',
      duration: map['duration'] ?? '25 mins',
      stops: List<String>.from(map['stops'] ?? ['Central Hub', 'North Colony', 'Science Park', 'Main Campus Gate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'routeName': routeName,
      'startPoint': startPoint,
      'endPoint': endPoint,
      'totalDistance': totalDistance,
      'duration': duration,
      'stops': stops,
    };
  }
}
