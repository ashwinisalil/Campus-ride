import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../auth/role_selection_screen.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _deptController;
  late TextEditingController _yearController;
  late TextEditingController _divController;
  late TextEditingController _prnController;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? 'Shravani');
    _emailController = TextEditingController(text: user?.email ?? 'shravani@campus.edu');
    _phoneController = TextEditingController(text: user?.phone ?? '+91 98765 00112');
    _deptController = TextEditingController(text: user?.department ?? 'Computer Engineering');
    _yearController = TextEditingController(text: user?.year ?? 'Third Year');
    _divController = TextEditingController(text: user?.division ?? 'A');
    _prnController = TextEditingController(text: user?.prn ?? 'PRN20248901');
  }

  void _saveProfile() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      department: _deptController.text,
      year: _yearController.text,
      division: _divController.text,
      prn: _prnController.text,
    );
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated & synchronized with Firestore!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final user = appState.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check_rounded : Icons.edit_rounded),
            onPressed: () {
              if (_isEditing) {
                _saveProfile();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Avatar
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 46,
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'S',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.name ?? 'Shravani',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${user?.department} • PRN: ${user?.prn}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dark Mode Toggle Glass Container
            GlassContainer(
              borderRadius: 18,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        appState.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: appState.isDarkMode ? Colors.amber : Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Dark Theme Mode',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Switch(
                    value: appState.isDarkMode,
                    onChanged: (val) => appState.toggleDarkMode(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Fields
            CustomTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Shravani',
              prefixIcon: Icons.person_rounded,
            ),
            CustomTextField(
              controller: _emailController,
              label: 'College Email',
              hint: 'shravani@campus.edu',
              prefixIcon: Icons.email_rounded,
            ),
            CustomTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: '+91 98765 00112',
              prefixIcon: Icons.phone_rounded,
            ),
            CustomTextField(
              controller: _prnController,
              label: 'PRN Roll Number',
              hint: 'PRN20248901',
              prefixIcon: Icons.badge_rounded,
            ),
            CustomTextField(
              controller: _deptController,
              label: 'Department',
              hint: 'Computer Engineering',
              prefixIcon: Icons.school_rounded,
            ),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _yearController,
                    label: 'Academic Year',
                    hint: 'Third Year',
                    prefixIcon: Icons.calendar_today_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextField(
                    controller: _divController,
                    label: 'Division',
                    hint: 'A',
                    prefixIcon: Icons.class_rounded,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            if (_isEditing)
              CustomButton(
                text: 'SAVE PROFILE CHANGES',
                icon: Icons.save_rounded,
                onPressed: _saveProfile,
              ),
            const SizedBox(height: 16),

            // Logout Button - Redirects to Role Selection showing all 3 portals & inner dashboards
            OutlinedButton.icon(
              onPressed: () {
                appState.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: const Text(
                'LOGOUT & SWITCH PORTAL',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.redAccent),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
