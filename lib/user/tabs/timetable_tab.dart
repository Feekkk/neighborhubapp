import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../pages/view_events.dart';
import '../pages/view_announcement.dart';

class TimetableTab extends StatefulWidget {
  const TimetableTab({super.key});

  @override
  State<TimetableTab> createState() => _TimetableTabState();
}

class _TimetableTabState extends State<TimetableTab> {
  DateTime _focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar section
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.08),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      surface: const Color(0xFF2A2A2A),
                      onSurface: Colors.white,
                      primary: const Color(0xFF6C63FF),
                    ),
                    textTheme: Theme.of(context).textTheme.copyWith(
                      bodyMedium: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                    ),
                    dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF232323)),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _focusedDay,
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                    onDateChanged: (date) {
                      setState(() {
                        _focusedDay = date;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  Icon(Icons.event, color: const Color(0xFF6C63FF), size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Upcoming Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: Colors.white24,
                      thickness: 1,
                      endIndent: 8,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewEventsPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'See More',
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('events')
                    .orderBy('dateTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No upcoming events.',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    );
                  }
                  final now = DateTime.now();
                  final events = snapshot.data!.docs.where((doc) {
                    final eventDate = (doc['dateTime'] as Timestamp).toDate();
                    return eventDate.isAfter(now) ||
                        (eventDate.year == now.year && eventDate.month == now.month && eventDate.day == now.day);
                  }).toList();
                  if (events.isEmpty) {
                    return Center(
                      child: Text(
                        'No upcoming events.',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      final eventDate = (event['dateTime'] as Timestamp).toDate();
                      return _ModernCard(
                        icon: Icons.event,
                        iconColor: const Color(0xFF6C63FF),
                        title: event['title'] ?? 'Untitled Event',
                        subtitle: DateFormat('MMM dd, yyyy • h:mm a').format(eventDate),
                        description: event['description'],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 36),
              Row(
                children: [
                  Icon(Icons.campaign, color: const Color(0xFF6C63FF), size: 22),
                  const SizedBox(width: 8),
                  const Text(
                    'Latest Announcements',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Divider(
                      color: Colors.white24,
                      thickness: 1,
                      endIndent: 8,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAnnouncementPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'See More',
                      style: TextStyle(
                        color: Color(0xFF6C63FF),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('announcements')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'No announcements yet.',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    );
                  }
                  final announcements = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      final ann = announcements[index];
                      final createdAt = (ann['createdAt'] as Timestamp?)?.toDate();
                      return _ModernCard(
                        icon: Icons.campaign,
                        iconColor: Colors.green,
                        title: ann['title'] ?? 'Announcement',
                        subtitle: createdAt != null ? DateFormat('MMM dd, yyyy • h:mm a').format(createdAt) : '',
                        description: ann['description'],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  '© 2025 NeighborHub. All rights reserved.',
                  style: TextStyle(color: Colors.white24, fontSize: 13, fontFamily: 'Poppins'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? description;
  const _ModernCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF23223A),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: iconColor.withOpacity(0.13)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (description != null && description!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              description!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ],
      ),
    );
  }
} 