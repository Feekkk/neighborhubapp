import 'package:flutter/material.dart';

class TimetableTab extends StatelessWidget {
  const TimetableTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Timetable',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
} 