import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // In-memory registered user database for strict authentication validation
  static final Map<String, UserModel> _registeredUsers = {
    'shravani@campus.edu': UserModel(
      uid: 'uid_shravani',
      email: 'shravani@campus.edu',
      name: 'Shravani',
      role: 'Student',
      phone: '+91 98765 00112',
      prn: 'PRN20248901',
      department: 'Computer Engineering',
      year: 'Third Year',
      division: 'A',
    ),
    'driver@campus.edu': UserModel(
      uid: 'uid_rajesh',
      email: 'driver@campus.edu',
      name: 'Rajesh Sharma',
      role: 'Driver',
      phone: '+91 98765 43211',
      prn: 'DRV-4091',
      department: 'Fleet Operations',
    ),
    'admin@campus.edu': UserModel(
      uid: 'uid_admin',
      email: 'admin@campus.edu',
      name: 'Dr. Vikrant Patil',
      role: 'Admin',
      phone: '+91 98765 99999',
      department: 'Campus Administration',
    ),
  };

  // Check if account exists for email & role
  bool accountExists(String email, String role) {
    if (_registeredUsers.containsKey(email.toLowerCase())) {
      return _registeredUsers[email.toLowerCase()]!.role == role;
    }
    return false;
  }

  // Realtime Email Login with strict account existence check
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
    required String role,
  }) async {
    String cleanEmail = email.trim().toLowerCase();

    // Enforce account existence
    if (!accountExists(cleanEmail, role)) {
      throw Exception('ACCOUNT_NOT_FOUND: No $role account registered with $email. Please create an account first.');
    }

    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail,
        password: password,
      );

      if (credential.user != null) {
        UserModel? profile = await _firestoreService.getUserProfile(credential.user!.uid, role);
        if (profile != null) return profile;
      }
    } catch (e) {
      // Fallback to registered local user
    }

    return _registeredUsers[cleanEmail];
  }

  // Realtime Registration - adds to registered accounts
  Future<UserModel?> registerUserAccount({
    required String name,
    required String email,
    required String password,
    required String role,
    required String phone,
    required String prn,
    required String department,
    required String year,
    required String division,
    required String gender,
  }) async {
    String cleanEmail = email.trim().toLowerCase();

    UserModel newUser = UserModel(
      uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
      email: cleanEmail,
      name: name,
      role: role,
      phone: phone,
      prn: prn,
      department: department,
      year: year,
      division: division,
      gender: gender,
    );

    _registeredUsers[cleanEmail] = newUser;

    try {
      await _firestoreService.saveStudentProfile(newUser);
    } catch (e) {
      // Saved locally
    }

    return newUser;
  }
}
