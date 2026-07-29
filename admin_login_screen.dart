import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../config/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../admin/admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _adminEmailController = TextEditingController(text: 'admin@campus.edu');
  final _passwordController = TextEditingController(text: 'admin123');
  bool _isLoading = false;

  void _handleAdminLogin() async {
    setState(() => _isLoading = true);
    final appState = Provider.of<AppState>(context, listen: false);
    bool success = await appState.loginUser(
      _adminEmailController.text,
      _passwordController.text,
      AppConstants.roleAdmin,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Administrator Command ⚙️',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Authorized personnel access for campus transportation monitoring.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _adminEmailController,
              label: 'Admin Official Email',
              hint: 'admin@campus.edu',
              prefixIcon: Icons.admin_panel_settings_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            CustomTextField(
              controller: _passwordController,
              label: 'Administrator Key Code',
              hint: '••••••••',
              prefixIcon: Icons.security_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'ACCESS ADMIN DASHBOARD',
              icon: Icons.dashboard_rounded,
              isLoading: _isLoading,
              onPressed: _handleAdminLogin,
            ),
          ],
        ),
      ),
    );
  }
}
