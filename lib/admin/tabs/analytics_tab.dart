import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import '../pages/view_annoucement.dart';
import '../pages/view_events.dart';

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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Get total users count
    final usersSnapshot = null;
    
    // Get reports data
    final reportsSnapshot = null;
    
    // Get announcements data
    final announcementsSnapshot = null;

    // Get events data
    final eventsSnapshot = null;

    setState(() {
      totalUsers = usersSnapshot.length;
      totalReports = reportsSnapshot.length;
      totalAnnouncements = announcementsSnapshot.length;
      totalEvents = eventsSnapshot.length;
    });

    // Process report data for chart
    final Map<String, int> reportsByDate = {};
    for (var doc in reportsSnapshot) {
      final data = doc;
      final timestamp = data['resolvedAt'];
      if (timestamp != null) {
        final date = timestamp;
        final dateString = '${date.day}/${date.month}/${date.year}';
        reportsByDate[dateString] = (reportsByDate[dateString] ?? 0) + 1;
      }
    }

    // Process announcement data for chart
    final Map<String, int> announcementsByDate = {};
    for (var doc in announcementsSnapshot) {
      final data = doc;
      final timestamp = data['createdAt'];
      if (timestamp != null) {
          final date = timestamp;
        final dateString = '${date.day}/${date.month}/${date.year}';
        announcementsByDate[dateString] = (announcementsByDate[dateString] ?? 0) + 1;
      }
    }

    // Process events data for chart
    final Map<String, int> eventsByDate = {};
    for (var doc in eventsSnapshot) {
      final data = doc;
      final timestamp = data['dateTime'];
      if (timestamp != null) {
          final date = timestamp;
        final dateString = '${date.day}/${date.month}/${date.year}';
        eventsByDate[dateString] = (eventsByDate[dateString] ?? 0) + 1;
      }
    }

    setState(() {
      reportData = reportsByDate.entries
          .map((e) => ReportData(e.key, e.value))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      announcementData = announcementsByDate.entries
          .map((e) => AnnouncementData(e.key, e.value))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));

      eventData = eventsByDate.entries
          .map((e) => EventData(e.key, e.value))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
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
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Users',
                  totalUsers.toString(),
                  Icons.people,
                  const Color(0xFF6C63FF),
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
                const Text(
                  'Reports Over Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
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
                const Text(
                  'Announcements Over Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
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
                const Text(
                  'Events Over Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
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