import 'dart:async';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/bus_model.dart';
import '../models/ride_history_model.dart';
import '../models/notification_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../services/location_service.dart';
import '../config/constants.dart';

class AppState extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // Current active logged in user
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  // Active Role ('Student', 'Driver', 'Admin')
  String _activeRole = AppConstants.roleStudent;
  String get activeRole => _activeRole;

  // Dark Mode Toggle
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Student Absentee Status for Today
  bool _isAbsentToday = false;
  bool get isAbsentToday => _isAbsentToday;

  // Driver Absentee Notifications List
  final List<Map<String, String>> _driverAbsenteeList = [
    {
      'studentName': 'Amit Kumar',
      'pickupPoint': 'North Campus Gate',
      'time': '07:45 AM',
    },
    {
      'studentName': 'Priya Singh',
      'pickupPoint': 'City Center Hub',
      'time': '08:00 AM',
    },
  ];
  List<Map<String, String>> get driverAbsenteeList => _driverAbsenteeList;

  // Active Bus Model
  BusModel _currentBus = BusModel(
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
  BusModel get currentBus => _currentBus;

  // Driver Live Status
  bool _isDriverLive = false;
  bool get isDriverLive => _isDriverLive;

  // Ride History & Notifications
  List<RideHistoryModel> _rideHistoryList = [];
  List<RideHistoryModel> get rideHistoryList => _rideHistoryList;

  List<AppNotification> _notificationsList = [];
  List<AppNotification> get notificationsList => _notificationsList;

  int _todaysAttendanceCount = 28;
  int get todaysAttendanceCount => _todaysAttendanceCount;

  Timer? _locationTimer;

  AppState() {
    _initDefaultUser();
    _loadInitialData();
  }

  void _initDefaultUser() {
    _currentUser = UserModel(
      uid: 'user_active_realtime',
      email: 'shravani@campus.edu',
      name: 'Shravani',
      role: AppConstants.roleStudent,
      phone: '+91 98765 00112',
      profilePicUrl: '',
      prn: 'PRN20248901',
      department: 'Computer Engineering',
      year: 'Third Year',
      division: 'A',
      gender: 'Female',
      currentBusNumber: 'Bus #04',
      pickupPoint: 'Central Square Hub',
    );
  }

  void _loadInitialData() async {
    _rideHistoryList = await _firestoreService.getRideHistory(_currentUser?.uid ?? '');
    _notificationsList = await _firestoreService.getNotifications();
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setRole(String role) {
    _activeRole = role;
    notifyListeners();
  }

  // Student Feature: Mark Not Coming Today
  void markNotComingToday() {
    _isAbsentToday = true;
    String studentName = _currentUser?.name ?? 'Shravani';
    String pickup = _currentUser?.pickupPoint ?? 'Central Square Hub';

    _driverAbsenteeList.insert(0, {
      'studentName': studentName,
      'pickupPoint': pickup,
      'time': 'Just now',
    });

    _notificationsList.insert(
      0,
      AppNotification(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Absence Marked',
        message: 'You have marked yourself as Not Coming Today. Driver $studentName has been notified.',
        timestamp: 'Just now',
        category: 'Alert',
      ),
    );

    notifyListeners();
  }

  // Realtime Registration
  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String prn,
    required String department,
    required String year,
    required String division,
    required String gender,
    required String role,
  }) async {
    UserModel? user = await _authService.registerUserAccount(
      name: name,
      email: email,
      password: password,
      role: role,
      phone: phone,
      prn: prn,
      department: department,
      year: year,
      division: division,
      gender: gender,
    );

    if (user != null) {
      _currentUser = user;
      _activeRole = role;
      notifyListeners();
      return true;
    }
    return false;
  }

  // Realtime Login
  Future<bool> loginUser(String email, String password, String role, {String? customName}) async {
    _activeRole = role;
    UserModel? user = await _authService.loginWithEmail(
      email: email,
      password: password,
      role: role,
    );

    if (user != null) {
      if (customName != null && customName.isNotEmpty) {
        user = UserModel(
          uid: user.uid,
          email: user.email,
          name: customName,
          role: role,
          phone: user.phone,
          prn: user.prn,
          department: user.department,
          year: user.year,
          division: user.division,
          gender: user.gender,
        );
      }
      _currentUser = user;
      _isAbsentToday = false;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _activeRole = AppConstants.roleStudent;
    _isAbsentToday = false;
    _initDefaultUser();
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String department,
    required String year,
    required String division,
    required String prn,
  }) {
    if (_currentUser == null) return;
    _currentUser = UserModel(
      uid: _currentUser!.uid,
      email: email,
      name: name,
      role: _currentUser!.role,
      phone: phone,
      profilePicUrl: _currentUser!.profilePicUrl,
      prn: prn,
      department: department,
      year: year,
      division: division,
      gender: _currentUser!.gender,
      studentIdCardUrl: _currentUser!.studentIdCardUrl,
      currentBusNumber: _currentUser!.currentBusNumber,
      pickupPoint: _currentUser!.pickupPoint,
    );
    _firestoreService.saveStudentProfile(_currentUser!);
    notifyListeners();
  }

  void toggleDriverLiveStatus() {
    _isDriverLive = !_isDriverLive;
    if (_isDriverLive) {
      _startLiveSimulatedUpdates();
    } else {
      _locationTimer?.cancel();
    }
    notifyListeners();
  }

  void _startLiveSimulatedUpdates() {
    _locationTimer?.cancel();
    _locationTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      double newLat = _currentBus.latitude + 0.0003;
      double newLng = _currentBus.longitude + 0.0003;
      _currentBus = BusModel(
        id: _currentBus.id,
        busNumber: _currentBus.busNumber,
        routeId: _currentBus.routeId,
        driverName: _currentBus.driverName,
        driverPhone: _currentBus.driverPhone,
        capacity: _currentBus.capacity,
        currentOccupancy: _currentBus.currentOccupancy,
        currentSpeed: 44.5,
        latitude: newLat,
        longitude: newLng,
        isRunning: true,
        estimatedArrival: '4 Mins',
        nextStop: 'Campus Engineering Block B',
      );
      notifyListeners();
    });
  }

  void markQRAttendance() {
    _todaysAttendanceCount++;
    _rideHistoryList.insert(
      0,
      RideHistoryModel(
        id: 'hist_${DateTime.now().millisecondsSinceEpoch}',
        date: 'Today, Live',
        time: 'Just now',
        route: 'Route A - City Hub',
        distance: '14.2 km',
        busNumber: _currentBus.busNumber,
        attendanceStatus: 'Verified',
      ),
    );
    notifyListeners();
  }

  Future<bool> launchGoogleMapsForBus() async {
    return await LocationService.openGoogleMaps(
      _currentBus.latitude,
      _currentBus.longitude,
      destinationLabel: 'Bus Location',
    );
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }
}
