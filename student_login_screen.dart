import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../config/constants.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_container.dart';
import '../student/student_main_screen.dart';
import 'registration_screen.dart';
import 'forgot_password_screen.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Shravani');
  final _emailController = TextEditingController(text: 'shravani@campus.edu');
  final _passwordController = TextEditingController(text: 'student123');
  bool _rememberMe = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final appState = Provider.of<AppState>(context, listen: false);

      try {
        bool success = await appState.loginUser(
          _emailController.text,
          _passwordController.text,
          AppConstants.roleStudent,
          customName: _nameController.text.trim().isNotEmpty ? _nameController.text.trim() : null,
        );
        setState(() => _isLoading = false);

        if (success && mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const StudentMainScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString().replaceAll('Exception: ', '')),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'REGISTER',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                  );
                },
              ),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'),
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
              const SizedBox(height: 10),
              Text(
                'Welcome Back Student! 👋',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign in using your registered credentials. Non-registered users must create an account first.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 30),
              CustomTextField(
                controller: _nameController,
                label: 'Student Name',
                hint: 'e.g. Shravani',
                prefixIcon: Icons.person_outline_rounded,
                validator: (val) => val == null || val.isEmpty ? 'Enter your name' : null,
              ),
              CustomTextField(
                controller: _emailController,
                label: 'College Email',
                hint: 'shravani@campus.edu',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val == null || !val.contains('@') ? 'Enter valid college email' : null,
              ),
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: '••••••••',
                prefixIcon: Icons.lock_rounded,
                isPassword: true,
                validator: (val) =>
                    val == null || val.length < 4 ? 'Enter valid password' : null,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _rememberMe,
                        onChanged: (val) => setState(() => _rememberMe = val ?? true),
                      ),
                      const Text('Remember Me'),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'STUDENT LOGIN',
                icon: Icons.login_rounded,
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const SizedBox(height: 20),
              GlassContainer(
                borderRadius: 16,
                onTap: _handleLogin,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_mobiledata_rounded, size: 30, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Text(
                      'Continue with Google Student SSO',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                      );
                    },
                    child: Text(
                      'Create Account Now',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
