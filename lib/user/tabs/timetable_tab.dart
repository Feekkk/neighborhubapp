import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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
  
  // Data states
  List<dynamic> events = [];
  List<dynamic> announcements = [];
  bool isLoadingEvents = true;
  bool isLoadingAnnouncements = true;
  String? eventsError;
  String? announcementsError;
  
  // API endpoints
  static const String baseUrl = 'http://192.168.1.120:3000/api';

  @override
  void initState() {
    super.initState();
    _loadEvents();
    _loadAnnouncements();
  }

  Future<void> _loadEvents() async {
    if (!mounted) return;
    
    setState(() {
      isLoadingEvents = true;
      eventsError = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/events'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Events data loaded: ${data.length} events');
        
        if (mounted) {
          setState(() {
            events = data;
            isLoadingEvents = false;
          });
        }
      } else {
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading events: $e');
      if (mounted) {
        setState(() {
          eventsError = 'Failed to load events: $e';
          isLoadingEvents = false;
        });
      }
    }
  }

  Future<void> _loadAnnouncements() async {
    if (!mounted) return;
    
    setState(() {
      isLoadingAnnouncements = true;
      announcementsError = null;
    });

    try {
      final response = await http.get(Uri.parse('$baseUrl/announcements'));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Announcements data loaded: ${data.length} announcements');
        
        if (mounted) {
          setState(() {
            announcements = data;
            isLoadingAnnouncements = false;
          });
        }
      } else {
        throw Exception('Failed to load announcements: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading announcements: $e');
      if (mounted) {
        setState(() {
          announcementsError = 'Failed to load announcements: $e';
          isLoadingAnnouncements = false;
        });
      }
    }
  }

  List<dynamic> _getUpcomingEvents() {
    final now = DateTime.now();
    return events.where((event) {
      try {
        final eventDate = DateTime.parse(event['date']);
        return eventDate.isAfter(now) ||
            (eventDate.year == now.year && 
             eventDate.month == now.month && 
             eventDate.day == now.day);
      } catch (e) {
        print('Error parsing event date: ${event['date']}, error: $e');
        return false;
      }
    }).toList();
  }

  List<dynamic> _getRecentAnnouncements() {
    // Get the 3 most recent announcements
    final sortedAnnouncements = List.from(announcements);
    sortedAnnouncements.sort((a, b) {
      try {
        final dateA = DateTime.parse(a['createdAt']);
        final dateB = DateTime.parse(b['createdAt']);
        return dateB.compareTo(dateA); // Most recent first
      } catch (e) {
        return 0;
      }
    });
    return sortedAnnouncements.take(3).toList();
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFFF5252);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'low':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final upcomingEvents = _getUpcomingEvents();
    final recentAnnouncements = _getRecentAnnouncements();

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
              
              // Upcoming Events Section
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
              
              // Events List
              if (isLoadingEvents)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  ),
                )
              else if (eventsError != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          eventsError!,
                          style: TextStyle(color: Colors.red[300], fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: _loadEvents,
                        child: const Text('Retry', style: TextStyle(color: Color(0xFF6C63FF))),
                      ),
                    ],
                  ),
                )
              else if (upcomingEvents.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.event_busy, color: Colors.grey[600], size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'No upcoming events',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                )
              else
                ...upcomingEvents.take(3).map((event) => _EventCard(event: event)).toList(),
              
              const SizedBox(height: 24),
              
              // Latest Announcements Section
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
              
              // Announcements List
              if (isLoadingAnnouncements)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
                  ),
                )
              else if (announcementsError != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          announcementsError!,
                          style: TextStyle(color: Colors.red[300], fontSize: 14),
                        ),
                      ),
                      TextButton(
                        onPressed: _loadAnnouncements,
                        child: const Text('Retry', style: TextStyle(color: Color(0xFF6C63FF))),
                      ),
                    ],
                  ),
                )
              else if (recentAnnouncements.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.campaign_outlined, color: Colors.grey[600], size: 40),
                      const SizedBox(height: 8),
                      Text(
                        'No announcements yet',
                        style: TextStyle(color: Colors.grey[500], fontSize: 16, fontFamily: 'Poppins'),
                      ),
                    ],
                  ),
                )
              else
                ...recentAnnouncements.map((announcement) => _AnnouncementCard(
                  announcement: announcement,
                  getPriorityColor: _getPriorityColor,
                )).toList(),
              
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

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    DateTime? eventDate;
    try {
      eventDate = DateTime.parse(event['date']);
    } catch (e) {
      print('Error parsing event date: ${event['date']}, error: $e');
    }

    final now = DateTime.now();
    final isToday = eventDate != null && 
                   eventDate.year == now.year && 
                   eventDate.month == now.month && 
                   eventDate.day == now.day;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showEventDetails(context, event, eventDate),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isToday 
                    ? const Color(0xFF6C63FF).withOpacity(0.3)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.event,
                    color: const Color(0xFF6C63FF),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event['title'] ?? 'Untitled Event',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (eventDate != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy • h:mm a').format(eventDate),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event, DateTime? eventDate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.event,
                        color: Color(0xFF6C63FF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['title'] ?? 'Untitled Event',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (eventDate != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy • h:mm a').format(eventDate),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (event['description'] != null && event['description'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event['description'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Map<String, dynamic> announcement;
  final Color Function(String) getPriorityColor;

  const _AnnouncementCard({
    required this.announcement,
    required this.getPriorityColor,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(announcement['createdAt']);
    } catch (e) {
      print('Error parsing announcement date: ${announcement['createdAt']}, error: $e');
    }

    final priority = announcement['priority'] ?? 'medium';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showAnnouncementDetails(context, announcement, createdAt),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: getPriorityColor(priority).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: getPriorityColor(priority).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.campaign,
                    color: getPriorityColor(priority),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        announcement['title'] ?? 'Announcement',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (createdAt != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy • h:mm a').format(createdAt),
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: getPriorityColor(priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    priority.toUpperCase(),
                    style: TextStyle(
                      color: getPriorityColor(priority),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAnnouncementDetails(BuildContext context, Map<String, dynamic> announcement, DateTime? createdAt) {
    final priority = announcement['priority'] ?? 'medium';
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: getPriorityColor(priority).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.campaign,
                        color: getPriorityColor(priority),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement['title'] ?? 'Announcement',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          if (createdAt != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy • h:mm a').format(createdAt),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getPriorityColor(priority).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: getPriorityColor(priority).withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        priority.toUpperCase(),
                        style: TextStyle(
                          color: getPriorityColor(priority),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                if (announcement['description'] != null && announcement['description'].toString().isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    announcement['description'],
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 