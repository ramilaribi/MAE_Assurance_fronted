import 'package:flutter/material.dart';
import 'package:perper/GradientButton.dart';
import '../Services/auth_service.dart';
import 'ResetPassword.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String email;
  VerifyCodeScreen({required this.email});

  @override
  _VerifyCodeScreenState createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();
  String? _resetToken;

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
            Text(
              "OTP",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Text(
              "Please enter the code sent to your email",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(hintText: 'Enter the code sent to your email'),
            ),
            const SizedBox(height: 20),
            GradientButton(
              text: "Verify",
              onPressed: () async {
                try {
                  print('Code being sent: ${_codeController.text}');
                  await _authService.otpVerification(widget.email, _codeController.text);
                  _resetToken = await _authService.getResetToken();
                  print('Token received: $_resetToken');
                  //Navigator.pop(context); // Close the current bottom sheet
                  Future.delayed(Duration(milliseconds: 300), () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => ResetPasswordScreen(
                        resetToken: _resetToken!,
                      ),
                    );
                  });
                } catch (e) {
                  print('Error verifying code: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error verifying code: $e')),
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
