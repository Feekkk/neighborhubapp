import 'package:flutter/material.dart';

class EmergencyTab extends StatelessWidget {
  const EmergencyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Emergency Resolve',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
} 