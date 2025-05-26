import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects/utils/snackBar.dart';
import 'package:projects/utils/text_field.dart';
import 'package:projects/utils/text_styles.dart';
import 'package:projects/utils/toast.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendResetEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
          email: _emailController.text.trim(),
        );
        showToast('Password reset email sent', true);
        _emailController.clear();
      } catch (e) {
        showToast('Error: ${e.toString()}', false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter your email to receive a password reset link',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text("Email", style: bodyTextStyle),
              const SizedBox(height: 5),
              CustomTextField(
                prefixIcon: Icons.email,
                controller: _emailController,
                isNumber: false,
                hintText: "Enter your email here",
              ),

              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                  ),
                  onPressed: () => _sendResetEmail(),
                  child: Text('Send Reset Link'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
