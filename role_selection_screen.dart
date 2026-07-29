import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../config/constants.dart';
import '../../widgets/glass_container.dart';
import 'student_login_screen.dart';
import 'driver_login_screen.dart';
import 'admin_login_screen.dart';
import 'registration_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Animated Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF070E20), Color(0xFF0F2B5B), Color(0xFF00B4D8)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 56)
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 10),
                  const Text(
                    'CAMPUS RIDE',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.extrabold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 6),
                  const Text(
                    'Smart Transportation • Authentication & Role Control',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.white70),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 30),

                  // Student Role Card with Login & Create Account Options
                  _buildRoleCard(
                    context,
                    title: 'Student Portal',
                    subtitle: 'Real-time bus tracking, ETA & attendance',
                    icon: Icons.school_rounded,
                    color: Colors.blueAccent,
                    onLogin: () {
                      appState.setRole(AppConstants.roleStudent);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StudentLoginScreen()),
                      );
                    },
                    onCreateAccount: () {
                      appState.setRole(AppConstants.roleStudent);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                  ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.1, end: 0),
                  const SizedBox(height: 18),

                  // Driver Role Card with Login & Create Account Options
                  _buildRoleCard(
                    context,
                    title: 'Driver Console',
                    subtitle: 'Broadcast GPS location & view absentees',
                    icon: Icons.airline_seat_recline_extra_rounded,
                    color: Colors.emeraldGreen,
                    onLogin: () {
                      appState.setRole(AppConstants.roleDriver);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DriverLoginScreen()),
                      );
                    },
                    onCreateAccount: () {
                      appState.setRole(AppConstants.roleDriver);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                  ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.1, end: 0),
                  const SizedBox(height: 18),

                  // Admin Role Card with Login & Create Account Options
                  _buildRoleCard(
                    context,
                    title: 'Admin Command',
                    subtitle: 'Fleet status, student/driver lists & reports',
                    icon: Icons.admin_panel_settings_rounded,
                    color: Colors.amber,
                    onLogin: () {
                      appState.setRole(AppConstants.roleAdmin);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
                      );
                    },
                    onCreateAccount: () {
                      appState.setRole(AppConstants.roleAdmin);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                  ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.1, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onLogin,
    required VoidCallback onCreateAccount,
  }) {
    return GlassContainer(
      borderRadius: 22,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onLogin,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: onCreateAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
