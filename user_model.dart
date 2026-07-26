class UserModel {
  final String uid;
  final String email;
  final String name;
  final String role; // Student, Driver, Admin
  final String phone;
  final String profilePicUrl;
  final String prn;
  final String department;
  final String year;
  final String division;
  final String gender;
  final String studentIdCardUrl;
  final String currentBusNumber;
  final String pickupPoint;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.phone = '',
    this.profilePicUrl = '',
    this.prn = '',
    this.department = 'Computer Engineering',
    this.year = 'Third Year',
    this.division = 'A',
    this.gender = 'Not specified',
    this.studentIdCardUrl = '',
    this.currentBusNumber = 'Bus #04',
    this.pickupPoint = 'Central Square',
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'] ?? 'Student User',
      role: map['role'] ?? 'Student',
      phone: map['phone'] ?? '',
      profilePicUrl: map['profilePicUrl'] ?? '',
      prn: map['prn'] ?? '',
      department: map['department'] ?? 'Computer Engineering',
      year: map['year'] ?? 'Third Year',
      division: map['division'] ?? 'A',
      gender: map['gender'] ?? 'Female',
      studentIdCardUrl: map['studentIdCardUrl'] ?? '',
      currentBusNumber: map['currentBusNumber'] ?? 'Bus #04',
      pickupPoint: map['pickupPoint'] ?? 'Central Square',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'phone': phone,
      'profilePicUrl': profilePicUrl,
      'prn': prn,
      'department': department,
      'year': year,
      'division': division,
      'gender': gender,
      'studentIdCardUrl': studentIdCardUrl,
      'currentBusNumber': currentBusNumber,
      'pickupPoint': pickupPoint,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
