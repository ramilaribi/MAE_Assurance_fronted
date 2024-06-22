import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:perper/GradientButton.dart';
import 'package:perper/Screens/login.dart';
import 'package:perper/fade_animationtest.dart';
import '../Services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String resetToken;
  ResetPasswordScreen({required this.resetToken});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _passwordChanged = false;

  @override
  Widget build(BuildContext context) {
    return _passwordChanged ? _buildPasswordChangedContent(context) : _buildResetPasswordContent(context);
  }

  Widget _buildResetPasswordContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInAnimation(
              delay: 1,
              child: Text(
                "Reset Password",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            FadeInAnimation(
              delay: 1.5,
              child: Text(
                "Please enter your new password below",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 30),
            FadeInAnimation(
              delay: 2,
              child: TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Enter new password'),
              ),
            ),
            const SizedBox(height: 20),
            FadeInAnimation(
              delay: 2.5,
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Confirm new password'),
              ),
            ),
            const SizedBox(height: 30),
            FadeInAnimation(
              delay: 3,
              child: GradientButton(
                text: "Reset Password",
                onPressed: () async {
                  if (_newPasswordController.text == _confirmPasswordController.text) {
                    try {
                      await _authService.resetPassword(_newPasswordController.text);
                      setState(() {
                        _passwordChanged = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Password reset successfully!')),
                      );
                    } catch (e) {
                      print('Error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Passwords do not match')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordChangedContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9F4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeInAnimation(
              delay: 1,
              child: Text(
                "Password Changed!",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            FadeInAnimation(
              delay: 1.5,
              child: Text(
                "Your password has been changed successfully",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 30),
            FadeInAnimation(
              delay: 2,
              child: GradientButton(
                text: "Back to Login",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
