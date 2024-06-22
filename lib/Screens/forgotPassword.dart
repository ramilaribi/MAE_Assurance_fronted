import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:perper/GradientButton.dart';
import 'package:perper/fade_animationtest.dart';
import '../Services/auth_service.dart';
import 'verifyCode.dart';  // Ensure this import matches your project structure

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
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
                "Forgot Password",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
                        const SizedBox(height: 20),

            FadeInAnimation(
              delay: 1.5,
              child: Text(
                "Please enter your email or identifier",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 10),
            FadeInAnimation(
              delay: 2,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Enter your email or identifier'),
              ),
            ),
            const SizedBox(height: 20),
  GradientButton(
  text: "Submit",
  onPressed: () async {
    try {
      await _authService.forgotPassword(_emailController.text);
      Navigator.pop(context);
      showVerifyCodeSheet(context, _emailController.text); // Display VerifyCodeScreen as bottom sheet
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  },
),
          ],
        ),
      ),
    );
  }
}
void showVerifyCodeSheet(BuildContext context, String email) {
  showModalBottomSheet(
    
    context: context,
    isScrollControlled: true,
    builder: (context) => VerifyCodeScreen(email: email),
  );
}

