import 'package:flutter/material.dart';

class GenerateReportPage extends StatelessWidget {
  const GenerateReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate Report', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: const SizedBox.shrink(),
    );
  }
}
