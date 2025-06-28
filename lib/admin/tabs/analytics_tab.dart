import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import '../pages/view_annoucement.dart';
import '../pages/view_events.dart';
import '../pages/view_user.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  int totalUsers = 0;
  int totalReports = 0;
  int totalAnnouncements = 0;
  int totalEvents = 0;
  List<ReportData> reportData = [];
  List<AnnouncementData> announcementData = [];
  List<EventData> eventData = [];
  bool isLoading = true;
  String? errorMessage;

  // Backend endpoints
  static const String baseUrl = 'http://192.168.1.120:3000/api';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch reports
      final reportsResponse = await http.get(Uri.parse('$baseUrl/reports'));
      if (reportsResponse.statusCode != 200) {
        throw Exception('Failed to load reports: ${reportsResponse.statusCode}');
      }
      final reportsSnapshot = jsonDecode(reportsResponse.body);
      print('Reports data: $reportsSnapshot');

      // Fetch announcements
      final announcementsResponse = await http.get(Uri.parse('$baseUrl/announcements'));
      if (announcementsResponse.statusCode != 200) {
        throw Exception('Failed to load announcements: ${announcementsResponse.statusCode}');
      }
      final announcementsSnapshot = jsonDecode(announcementsResponse.body);
      print('Announcements data: $announcementsSnapshot');

      // Fetch events
      final eventsResponse = await http.get(Uri.parse('$baseUrl/events'));
      if (eventsResponse.statusCode != 200) {
        throw Exception('Failed to load events: ${eventsResponse.statusCode}');
      }
      final eventsSnapshot = jsonDecode(eventsResponse.body);
      print('Events data: $eventsSnapshot');

      setState(() {
        totalReports = reportsSnapshot.length;
        totalAnnouncements = announcementsSnapshot.length;
        totalEvents = eventsSnapshot.length;
      });

      // Process report data for chart - using createdAt instead of resolvedAt
      final Map<String, int> reportsByDate = {};
      for (var data in reportsSnapshot) {
        final timestamp = data['createdAt'];
        if (timestamp != null) {
          try {
            final date = DateTime.parse(timestamp);
            final dateString = '${date.day}/${date.month}/${date.year}';
            reportsByDate[dateString] = (reportsByDate[dateString] ?? 0) + 1;
          } catch (e) {
            print('Error parsing report date: $timestamp, error: $e');
          }
        }
      }
      print('Processed reports by date: $reportsByDate');

      // Process announcement data for chart
      final Map<String, int> announcementsByDate = {};
      for (var data in announcementsSnapshot) {
        final timestamp = data['createdAt'];
        if (timestamp != null) {
          try {
            final date = DateTime.parse(timestamp);
            final dateString = '${date.day}/${date.month}/${date.year}';
            announcementsByDate[dateString] = (announcementsByDate[dateString] ?? 0) + 1;
          } catch (e) {
            print('Error parsing announcement date: $timestamp, error: $e');
          }
        }
      }
      print('Processed announcements by date: $announcementsByDate');

      // Process events data for chart
      final Map<String, int> eventsByDate = {};
      for (var data in eventsSnapshot) {
        final timestamp = data['date'];
        if (timestamp != null) {
          try {
            final date = DateTime.parse(timestamp);
            final dateString = '${date.day}/${date.month}/${date.year}';
            eventsByDate[dateString] = (eventsByDate[dateString] ?? 0) + 1;
          } catch (e) {
            print('Error parsing event date: $timestamp, error: $e');
          }
        }
      }
      print('Processed events by date: $eventsByDate');

      // If no data is available, generate sample data for testing
      if (reportsByDate.isEmpty && announcementsByDate.isEmpty && eventsByDate.isEmpty) {
        print('No data available, generating sample data for testing');
        _generateSampleData();
        return;
      }

      setState(() {
        reportData = reportsByDate.entries
            .map((e) => ReportData(e.key, e.value))
            .toList()
          ..sort((a, b) {
            // Parse dates for proper sorting
            final dateA = _parseDateString(a.date);
            final dateB = _parseDateString(b.date);
            return dateA.compareTo(dateB);
          });

        announcementData = announcementsByDate.entries
            .map((e) => AnnouncementData(e.key, e.value))
            .toList()
          ..sort((a, b) {
            // Parse dates for proper sorting
            final dateA = _parseDateString(a.date);
            final dateB = _parseDateString(b.date);
            return dateA.compareTo(dateB);
          });

        eventData = eventsByDate.entries
            .map((e) => EventData(e.key, e.value))
            .toList()
          ..sort((a, b) {
            // Parse dates for proper sorting
            final dateA = _parseDateString(a.date);
            final dateB = _parseDateString(b.date);
            return dateA.compareTo(dateB);
          });

        print('Final reportData: ${reportData.map((e) => '${e.date}: ${e.count}').toList()}');
        print('Final announcementData: ${announcementData.map((e) => '${e.date}: ${e.count}').toList()}');
        print('Final eventData: ${eventData.map((e) => '${e.date}: ${e.count}').toList()}');

        isLoading = false;
      });
    } catch (e) {
      print('Error loading analytics data: $e');
      setState(() {
        errorMessage = 'Failed to load data: $e';
        isLoading = false;
      });
    }
  }

  void _generateSampleData() {
    final now = DateTime.now();
    final Map<String, int> sampleReports = {};
    final Map<String, int> sampleAnnouncements = {};
    final Map<String, int> sampleEvents = {};

    // Generate sample data for the last 7 days
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateString = '${date.day}/${date.month}/${date.year}';
      
      sampleReports[dateString] = (i % 3) + 1; 
      sampleAnnouncements[dateString] = (i % 2) + 1; 
      sampleEvents[dateString] = (i % 4) + 1; 
    }

    setState(() {
      reportData = sampleReports.entries
          .map((e) => ReportData(e.key, e.value))
          .toList()
        ..sort((a, b) {
          final dateA = _parseDateString(a.date);
          final dateB = _parseDateString(b.date);
          return dateA.compareTo(dateB);
        });

      announcementData = sampleAnnouncements.entries
          .map((e) => AnnouncementData(e.key, e.value))
          .toList()
        ..sort((a, b) {
          final dateA = _parseDateString(a.date);
          final dateB = _parseDateString(b.date);
          return dateA.compareTo(dateB);
        });

      eventData = sampleEvents.entries
          .map((e) => EventData(e.key, e.value))
          .toList()
        ..sort((a, b) {
          final dateA = _parseDateString(a.date);
          final dateB = _parseDateString(b.date);
          return dateA.compareTo(dateB);
        });

      totalReports = sampleReports.values.reduce((a, b) => a + b);
      totalAnnouncements = sampleAnnouncements.values.reduce((a, b) => a + b);
      totalEvents = sampleEvents.values.reduce((a, b) => a + b);

      print('Generated sample data:');
      print('Reports: ${reportData.map((e) => '${e.date}: ${e.count}').toList()}');
      print('Announcements: ${announcementData.map((e) => '${e.date}: ${e.count}').toList()}');
      print('Events: ${eventData.map((e) => '${e.date}: ${e.count}').toList()}');

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6C63FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics,
                    color: Color(0xFF6C63FF),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics Dashboard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Monitor your community insights',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                    ),
                  )
                else
                  IconButton(
                    onPressed: _loadData,
                    icon: const Icon(
                      Icons.refresh,
                      color: Color(0xFF6C63FF),
                    ),
                    tooltip: 'Refresh data',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Error message
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.red),
                    onPressed: _loadData,
                  ),
                ],
              ),
            ),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewUser(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    'Total Users',
                    totalUsers.toString(),
                    Icons.people,
                    const Color(0xFF6C63FF),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Total Reports',
                  totalReports.toString(),
                  Icons.report,
                  Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewAnnouncement(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    'Total Announcements',
                    totalAnnouncements.toString(),
                    Icons.announcement,
                    Colors.green,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ViewEvents(),
                      ),
                    );
                  },
                  child: _buildStatCard(
                    'Total Events',
                    totalEvents.toString(),
                    Icons.event,
                    Colors.purple,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Reports Chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Reports Over Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (reportData.isEmpty)
                      const Text(
                        'No data available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (reportData.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.white70),
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: const TextStyle(color: Colors.white70),
                        majorGridLines: const MajorGridLines(width: 0.5, color: Colors.white24),
                      ),
                      legend: Legend(
                        isVisible: true,
                        textStyle: const TextStyle(color: Colors.white70),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<ReportData, String>>[
                        ColumnSeries<ReportData, String>(
                          name: 'Reports',
                          dataSource: reportData,
                          xValueMapper: (ReportData data, _) => data.date,
                          yValueMapper: (ReportData data, _) => data.count,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(color: Colors.white70),
                          ),
                          color: const Color(0xFF6C63FF),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const Text(
                      'No report data to display',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Announcements Chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Announcements Over Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (announcementData.isEmpty)
                      const Text(
                        'No data available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (announcementData.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.white70),
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: const TextStyle(color: Colors.white70),
                        majorGridLines: const MajorGridLines(width: 0.5, color: Colors.white24),
                      ),
                      legend: Legend(
                        isVisible: true,
                        textStyle: const TextStyle(color: Colors.white70),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<AnnouncementData, String>>[
                        ColumnSeries<AnnouncementData, String>(
                          name: 'Announcements',
                          dataSource: announcementData,
                          xValueMapper: (AnnouncementData data, _) => data.date,
                          yValueMapper: (AnnouncementData data, _) => data.count,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(color: Colors.white70),
                          ),
                          color: Colors.green,
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const Text(
                      'No announcement data to display',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Events Chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Events Over Time',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (eventData.isEmpty)
                      const Text(
                        'No data available',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                if (eventData.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(
                        labelStyle: const TextStyle(color: Colors.white70),
                        majorGridLines: const MajorGridLines(width: 0),
                      ),
                      primaryYAxis: NumericAxis(
                        labelStyle: const TextStyle(color: Colors.white70),
                        majorGridLines: const MajorGridLines(width: 0.5, color: Colors.white24),
                      ),
                      legend: Legend(
                        isVisible: true,
                        textStyle: const TextStyle(color: Colors.white70),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<EventData, String>>[
                        ColumnSeries<EventData, String>(
                          name: 'Events',
                          dataSource: eventData,
                          xValueMapper: (EventData data, _) => data.date,
                          yValueMapper: (EventData data, _) => data.count,
                          dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            labelAlignment: ChartDataLabelAlignment.top,
                            textStyle: TextStyle(color: Colors.white70),
                          ),
                          color: Colors.purple,
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: 300,
                    alignment: Alignment.center,
                    child: const Text(
                      'No event data to display',
                      style: TextStyle(color: Colors.white54),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  DateTime _parseDateString(String dateString) {
    // Parse date string in format "DD/MM/YYYY"
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    // Fallback to current date if parsing fails
    return DateTime.now();
  }
}

class ReportData {
  final String date;
  final int count;

  ReportData(this.date, this.count);
}

class AnnouncementData {
  final String date;
  final int count;

  AnnouncementData(this.date, this.count);
}

class EventData {
  final String date;
  final int count;

  EventData(this.date, this.count);
} 