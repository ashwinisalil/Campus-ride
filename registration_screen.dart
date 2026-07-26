import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../config/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_container.dart';
import '../../services/location_service.dart';
import '../student/student_main_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: 'Shravani');
  final _emailController = TextEditingController(text: 'shravani@campus.edu');
  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _prnController = TextEditingController(text: 'PRN20248901');
  final _passwordController = TextEditingController(text: 'password123');
  final _confirmPasswordController = TextEditingController(text: 'password123');

  String _selectedRole = AppConstants.roleStudent;
  String _selectedDepartment = 'Computer Engineering';
  String _selectedYear = 'Third Year';
  String _selectedDivision = 'A';
  String _selectedGender = 'Female';

  bool _locationGranted = false;
  bool _idUploaded = false;
  bool _isLoading = false;

  void _requestLocation() async {
    bool success = await LocationService.requestPermission();
    setState(() => _locationGranted = success);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Location permission granted!' : 'Permission denied'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match'), backgroundColor: Colors.red),
        );
        return;
      }

      setState(() => _isLoading = true);
      final appState = Provider.of<AppState>(context, listen: false);

      bool success = await appState.registerUser(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        phone: _phoneController.text,
        prn: _prnController.text,
        department: _selectedDepartment,
        year: _selectedYear,
        division: _selectedDivision,
        gender: _selectedGender,
        role: _selectedRole,
      );

      setState(() => _isLoading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created & Firestore synchronized!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const StudentMainScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Upload Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      child: Icon(Icons.person_rounded, size: 50, color: Theme.of(context).primaryColor),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Role Selector Dropdown
              const Text('Account Role', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              GlassContainer(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedRole,
                    isExpanded: true,
                    items: [AppConstants.roleStudent, AppConstants.roleDriver]
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedRole = val!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'e.g. Shravani',
                prefixIcon: Icons.person_outline_rounded,
                validator: (val) => val == null || val.isEmpty ? 'Enter name' : null,
              ),
              CustomTextField(
                controller: _emailController,
                label: 'College Email',
                hint: 'shravani@campus.edu',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val == null || !val.contains('@') ? 'Enter valid email' : null,
              ),
              CustomTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '+91 98765 43210',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              CustomTextField(
                controller: _prnController,
                label: 'PRN / Roll Number',
                hint: 'PRN20248901',
                prefixIcon: Icons.badge_outlined,
              ),

              // Department Dropdown
              const Text('Department', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              GlassContainer(
                borderRadius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDepartment,
                    isExpanded: true,
                    items: ['Computer Engineering', 'Information Technology', 'Electronics', 'Mechanical', 'Civil']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedDepartment = val!),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Year & Division Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Year', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedYear,
                              isExpanded: true,
                              items: ['First Year', 'Second Year', 'Third Year', 'Final Year']
                                  .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedYear = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Division', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        GlassContainer(
                          borderRadius: 14,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedDivision,
                              isExpanded: true,
                              items: ['A', 'B', 'C', 'D']
                                  .map((div) => DropdownMenuItem(value: div, child: Text(div)))
                                  .toList(),
                              onChanged: (val) => setState(() => _selectedDivision = val!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
              ),

              // Upload Student ID Card Button
              GlassContainer(
                borderRadius: 16,
                onTap: () {
                  setState(() => _idUploaded = !_idUploaded);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _idUploaded ? Icons.check_circle_rounded : Icons.upload_file_rounded,
                      color: _idUploaded ? Colors.green : Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _idUploaded ? 'Student ID Uploaded ✓' : 'Upload Student ID Card Photo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _idUploaded ? Colors.green : Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Location Permission Card
              GlassContainer(
                borderRadius: 16,
                onTap: _requestLocation,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _locationGranted ? Icons.location_on_rounded : Icons.my_location_rounded,
                      color: _locationGranted ? Colors.green : Colors.orangeAccent,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _locationGranted ? 'GPS Permission Granted ✓' : 'Grant Location Permission',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _locationGranted ? Colors.green : Colors.orangeAccent,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'CREATE ACCOUNT & SAVE TO FIRESTORE',
                icon: Icons.check_circle_outline_rounded,
                isLoading: _isLoading,
                onPressed: _handleRegister,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
