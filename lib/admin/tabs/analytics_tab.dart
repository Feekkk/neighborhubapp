import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalyticsTab extends StatefulWidget {
  const AnalyticsTab({super.key});

  @override
  State<AnalyticsTab> createState() => _AnalyticsTabState();
}

class _AnalyticsTabState extends State<AnalyticsTab> {
  int totalUsers = 0;
  int totalReports = 0;
  List<ReportData> reportData = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Get total users count
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      totalUsers = usersSnapshot.size;
    });

    // Get reports data
    final reportsSnapshot = await FirebaseFirestore.instance.collection('report').get();
    setState(() {
      totalReports = reportsSnapshot.size;
    });

    // Process report data for chart
    final Map<String, int> reportsByDate = {};
    for (var doc in reportsSnapshot.docs) {
      final data = doc.data();
      final timestamp = data['resolvedAt'] as Timestamp?;
      if (timestamp != null) {
        final date = timestamp.toDate();
        final dateString = '${date.day}/${date.month}/${date.year}';
        reportsByDate[dateString] = (reportsByDate[dateString] ?? 0) + 1;
      }
    }

    setState(() {
      reportData = reportsByDate.entries
          .map((e) => ReportData(e.key, e.value))
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