import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../config/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../driver/driver_dashboard_screen.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _driverIdController = TextEditingController(text: 'DRV-4091');
  final _passwordController = TextEditingController(text: 'driver123');
  bool _isLoading = false;

  void _handleDriverLogin() async {
    setState(() => _isLoading = true);
    final appState = Provider.of<AppState>(context, listen: false);
    bool success = await appState.loginUser(
      _driverIdController.text,
      _passwordController.text,
      AppConstants.roleDriver,
    );
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DriverDashboardScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Portal Login'),
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
              'Driver Console Login 🚌',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your assigned Driver ID to manage trips and broadcast live location.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _driverIdController,
              label: 'Driver ID Number',
              hint: 'e.g. DRV-4091',
              prefixIcon: Icons.badge_rounded,
            ),
            CustomTextField(
              controller: _passwordController,
              label: 'Driver Access Password',
              hint: '••••••••',
              prefixIcon: Icons.key_rounded,
              isPassword: true,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'LOGIN TO DRIVER CONSOLE',
              icon: Icons.directions_bus_filled_rounded,
              isLoading: _isLoading,
              onPressed: _handleDriverLogin,
            ),
          ],
        ),
      ),
    );
  }
}
