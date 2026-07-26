import 'package:flutter/material.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              'Forgot Your Password? 🔑',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your registered campus email to receive a password reset link.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            CustomTextField(
              controller: _emailController,
              label: 'Registered Email',
              hint: 'shravani@campus.edu',
              prefixIcon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'SEND RESET LINK',
              icon: Icons.send_rounded,
              onPressed: () {
                setState(() => _sent = true);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Reset email sent! Please check your inbox.'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ),
            if (_sent) ...[
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  '✓ Reset link sent to your college inbox.',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
