import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    this.width = double.infinity,
    this.height = 50.0,
    required this.onPressed, // Ensure this is passed down to the ElevatedButton
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          colors: [Colors.green,Color.fromARGB(255, 20, 123, 24)],
          begin: Alignment.centerLeft,
          end: Alignment(0.92, 0),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
          Colors.transparent, // primary is the correct property name
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed, // Pass the onPressed callback here
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
          colors: [Colors.green,Color.fromARGB(255, 20, 123, 24)],
              begin: Alignment.centerLeft,
              end: Alignment(0.92, 0),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              minWidth: width,
              minHeight: height,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}