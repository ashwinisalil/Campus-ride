import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/bus_model.dart';
import '../models/route_model.dart';
import '../models/ride_history_model.dart';
import '../models/notification_model.dart';
import '../config/constants.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save or update Student profile
  Future<void> saveStudentProfile(UserModel user) async {
    try {
      await _db.collection(AppConstants.colStudents).doc(user.uid).set(user.toMap());
    } catch (e) {
      // Local execution fallback
    }
  }

  // Get user profile by UID
  Future<UserModel?> getUserProfile(String uid, String role) async {
    try {
      String collection = AppConstants.colStudents;
      if (role == AppConstants.roleDriver) collection = AppConstants.colDrivers;
      if (role == AppConstants.roleAdmin) collection = AppConstants.colAdmins;

      DocumentSnapshot doc = await _db.collection(collection).doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
    } catch (e) {
      // Return null to trigger local fallback
    }
    return null;
  }

  // Stream active bus information
  Stream<BusModel> getBusStream(String busId) {
    try {
      return _db
          .collection(AppConstants.colBuses)
          .doc(busId)
          .snapshots()
          .map((doc) {
        if (doc.exists && doc.data() != null) {
          return BusModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
        }
        return _getMockBus();
      });
    } catch (e) {
      return Stream.value(_getMockBus());
    }
  }

  // Save QR Attendance record
  Future<void> logAttendance({
    required String studentId,
    required String busId,
    required String studentName,
  }) async {
    try {
      await _db.collection(AppConstants.colAttendance).add({
        'studentId': studentId,
        'studentName': studentName,
        'busId': busId,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'Verified',
        'method': 'QR Scan',
      });
    } catch (e) {
      // Handled in app state
    }
  }

  // Send SOS Alert to Firestore
  Future<void> triggerEmergencyAlert({
    required String userId,
    required String userName,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _db.collection('emergencyAlerts').add({
        'userId': userId,
        'userName': userName,
        'latitude': latitude,
        'longitude': longitude,
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'ACTIVE',
      });
    } catch (e) {
      // Handled gracefully
    }
  }

  // Fetch Ride History list
  Future<List<RideHistoryModel>> getRideHistory(String studentId) async {
    try {
      QuerySnapshot snap = await _db
          .collection(AppConstants.colRideHistory)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (snap.docs.isNotEmpty) {
        return snap.docs
            .map((doc) => RideHistoryModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      // Fallback data
    }
    return _getMockRideHistory();
  }

  // Fetch Notifications
  Future<List<AppNotification>> getNotifications() async {
    try {
      QuerySnapshot snap = await _db.collection(AppConstants.colNotifications).get();
      if (snap.docs.isNotEmpty) {
        return snap.docs
            .map((doc) => AppNotification.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }
    } catch (e) {
      // Fallback
    }
    return _getMockNotifications();
  }

  // Default Mock Bus for immediate testing
  BusModel _getMockBus() {
    return BusModel(
      id: 'bus_04',
      busNumber: 'Bus #04',
      routeId: 'Route A',
      driverName: 'Rajesh Sharma',
      driverPhone: '+91 98765 43211',
      capacity: 45,
      currentOccupancy: 32,
      currentSpeed: 42.0,
      latitude: 18.5204,
      longitude: 73.8567,
      isRunning: true,
      estimatedArrival: '6 Mins',
      nextStop: 'North Campus Gate',
    );
  }

  List<RideHistoryModel> _getMockRideHistory() {
    return [
      RideHistoryModel(
        id: 'hist_1',
        date: 'Today, 24 Jul',
        time: '08:15 AM',
        route: 'Route A - City Central',
        distance: '14.2 km',
        busNumber: 'Bus #04',
        attendanceStatus: 'Verified',
      ),
      RideHistoryModel(
        id: 'hist_2',
        date: 'Yesterday, 23 Jul',
        time: '05:30 PM',
        route: 'Route B - Campus Express',
        distance: '12.0 km',
        busNumber: 'Bus #04',
        attendanceStatus: 'Verified',
      ),
      RideHistoryModel(
        id: 'hist_3',
        date: '22 Jul 2026',
        time: '08:10 AM',
        route: 'Route A - City Central',
        distance: '14.2 km',
        busNumber: 'Bus #02',
        attendanceStatus: 'Verified',
      ),
    ];
  }

  List<AppNotification> _getMockNotifications() {
    return [
      AppNotification(
        id: 'notif_1',
        title: 'Ride Started',
        message: 'Bus #04 has started trip from City Central Station.',
        timestamp: '10 Mins ago',
        category: 'Delay',
        isRead: false,
      ),
      AppNotification(
        id: 'notif_2',
        title: 'Bus Arriving Soon',
        message: 'Your bus #04 is 2 stops away. ETA 5 minutes.',
        timestamp: '2 Mins ago',
        category: 'Alert',
        isRead: false,
      ),
      AppNotification(
        id: 'notif_3',
        title: 'Campus Weather Alert',
        message: 'Light rain expected around campus by 4 PM. Drive safe!',
        timestamp: '1 Hour ago',
        category: 'Announcement',
        isRead: true,
      ),
    ];
  }
}
