class AppConstants {
  static const String appName = 'TrackMe';
  static const String appTagline = 'Smart Campus Ride & Live Tracking';
  static const String appVersion = '1.0.0';

  // Firestore Collections
  static const String colStudents = 'students';
  static const String colDrivers = 'drivers';
  static const String colAdmins = 'admins';
  static const String colBuses = 'buses';
  static const String colRoutes = 'routes';
  static const String colNotifications = 'notifications';
  static const String colAttendance = 'attendance';
  static const String colLocations = 'locations';
  static const String colRideHistory = 'rideHistory';
  static const String colFeedback = 'feedback';
  static const String colEmergencyContacts = 'emergencyContacts';
  static const String colUserSettings = 'userSettings';

  // Roles
  static const String roleStudent = 'Student';
  static const String roleDriver = 'Driver';
  static const String roleAdmin = 'Admin';

  // Default Location (Campus Coordinates)
  static const double defaultLat = 18.5204;
  static const double defaultLng = 73.8567;
  static const String defaultCollegeName = 'Campus Central Engineering College';

  // Security Phone
  static const String campusSecurityPhone = '+919876543210';
  static const String driverEmergencyPhone = '+919876543211';
}
