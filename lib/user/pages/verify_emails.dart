import 'package:flutter/material.dart';

class VerifyEmailsPage extends StatelessWidget {
  const VerifyEmailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Email Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Email Verification Page',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
