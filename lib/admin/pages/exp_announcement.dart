import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/api_config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ExpAnnouncementPage extends StatefulWidget {
  const ExpAnnouncementPage({Key? key}) : super(key: key);

  @override
  State<ExpAnnouncementPage> createState() => _ExpAnnouncementPageState();
}

class _ExpAnnouncementPageState extends State<ExpAnnouncementPage> {
  bool _isLoading = true;
  bool _isSchedulerLoading = true;
  bool _isManualCleanupLoading = false;
  bool _isForceCleanupLoading = false;
  bool _isExpiringLoading = true;
  String? _error;
  String? _schedulerError;
  String? _manualCleanupMsg;
  String? _forceCleanupMsg;
  String? _expiringError;
  Map<String, dynamic>? _summary;
  bool? _schedulerRunning;
  List<dynamic> _expiringAnnouncements = [];

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchExpiringSummary();
    _fetchSchedulerStatus();
    _fetchExpiringAnnouncements();
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> _fetchExpiringSummary() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/admin/announcements/expiring-summary'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _summary = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to fetch summary (${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchSchedulerStatus() async {
    setState(() {
      _isSchedulerLoading = true;
      _schedulerError = null;
    });
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/admin/scheduler/status'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _schedulerRunning = data['running'] == true;
          _isSchedulerLoading = false;
        });
      } else {
        setState(() {
          _schedulerError = 'Failed to fetch scheduler status (${response.statusCode})';
          _isSchedulerLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _schedulerError = 'Error: $e';
        _isSchedulerLoading = false;
      });
    }
  }

  Future<void> _fetchExpiringAnnouncements() async {
    setState(() {
      _isExpiringLoading = true;
      _expiringError = null;
    });
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/announcements/expiring'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _expiringAnnouncements = data['announcements'] ?? data;
          _isExpiringLoading = false;
        });
      } else {
        setState(() {
          _expiringError = 'Failed to fetch expiring announcements (${response.statusCode})';
          _isExpiringLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _expiringError = 'Error: $e';
        _isExpiringLoading = false;
      });
    }
  }

  Future<void> _triggerManualCleanup() async {
    setState(() {
      _isManualCleanupLoading = true;
      _manualCleanupMsg = null;
    });
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/announcements/cleanup'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _manualCleanupMsg = 'Manual cleanup triggered successfully.';
          _isManualCleanupLoading = false;
        });
        _fetchExpiringSummary();
        _fetchExpiringAnnouncements();
      } else {
        setState(() {
          _manualCleanupMsg = 'Failed to trigger manual cleanup (${response.statusCode})';
          _isManualCleanupLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _manualCleanupMsg = 'Error: $e';
        _isManualCleanupLoading = false;
      });
    }
  }

  Future<void> _triggerForceCleanup() async {
    setState(() {
      _isForceCleanupLoading = true;
      _forceCleanupMsg = null;
    });
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/admin/cleanup/force'),
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          _forceCleanupMsg = 'Force cleanup triggered successfully.';
          _isForceCleanupLoading = false;
        });
        _fetchExpiringSummary();
        _fetchExpiringAnnouncements();
      } else {
        setState(() {
          _forceCleanupMsg = 'Failed to trigger force cleanup (${response.statusCode})';
          _isForceCleanupLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _forceCleanupMsg = 'Error: $e';
        _isForceCleanupLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF23223A),
        elevation: 0,
        title: const Text('Expiring Announcements', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchExpiringSummary();
              _fetchSchedulerStatus();
              _fetchExpiringAnnouncements();
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          // Scheduler Status Card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xFF23223A),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.schedule, color: Color(0xFF6C63FF), size: 28),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Scheduler Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                        const SizedBox(height: 6),
                        _isSchedulerLoading
                            ? const LinearProgressIndicator(minHeight: 4, color: Color(0xFF6C63FF), backgroundColor: Colors.transparent)
                            : _schedulerError != null
                                ? Text(_schedulerError!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                                : Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 400),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _schedulerRunning == true ? Colors.green[900]!.withOpacity(0.15) : Colors.red[900]!.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(_schedulerRunning == true ? Icons.check_circle : Icons.cancel, size: 18, color: _schedulerRunning == true ? Colors.greenAccent : Colors.redAccent),
                                            const SizedBox(width: 6),
                                            Text(
                                              _schedulerRunning == true ? 'Running' : 'Not Running',
                                              style: TextStyle(
                                                color: _schedulerRunning == true ? Colors.greenAccent : Colors.redAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Color(0xFF6C63FF)),
                    onPressed: _fetchSchedulerStatus,
                    tooltip: 'Refresh Scheduler Status',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Expiring Announcements Summary Card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xFF23223A),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.warning_amber_rounded, color: Colors.deepOrange, size: 24),
                      SizedBox(width: 10),
                      Text('Expiring Announcements Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.deepOrange)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _isLoading
                      ? const LinearProgressIndicator(minHeight: 4, color: Colors.deepOrange)
                      : _error != null
                          ? Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                          : Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    'Count: ${_summary?['count'] ?? '-'}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange, fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                if (_summary != null && _summary!['titles'] != null && (_summary!['titles'] as List).isNotEmpty)
                                  Expanded(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: (_summary!['titles'] as List)
                                            .map<Widget>((title) => Container(
                                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.orange[100]?.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Text(title, style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600)),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Expiring Announcements List Card
          Card(
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xFF23223A),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.announcement_rounded, color: Color(0xFF6C63FF), size: 24),
                      SizedBox(width: 10),
                      Text('Announcements Expiring Soon', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF6C63FF))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _isExpiringLoading
                      ? const LinearProgressIndicator(minHeight: 4, color: Color(0xFF6C63FF))
                      : _expiringError != null
                          ? Text(_expiringError!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
                          : _expiringAnnouncements.isEmpty
                              ? Column(
                                  children: [
                                    const SizedBox(height: 12),
                                    Icon(Icons.inbox, size: 48, color: Colors.grey.withOpacity(0.4)),
                                    const SizedBox(height: 8),
                                    const Text('No announcements expiring soon.', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                                  ],
                                )
                              : Column(
                                  children: _expiringAnnouncements.map((a) => _ExpiringAnnouncementTile(announcement: a)).toList(),
                                ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Manual Cleanup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isManualCleanupLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.cleaning_services),
              label: const Text('Manual Cleanup', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: const Color(0xFF6C63FF).withOpacity(0.3),
              ),
              onPressed: _isManualCleanupLoading ? null : _triggerManualCleanup,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 16),
            child: Text(
              'This will manually trigger the cleanup process to remove expired announcements.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (_manualCleanupMsg != null) ...[
            const SizedBox(height: 8),
            Center(child: Text(_manualCleanupMsg!, style: const TextStyle(color: Color(0xFF6C63FF), fontWeight: FontWeight.bold))),
          ],
          const SizedBox(height: 16),
          // Force Cleanup Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: _isForceCleanupLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.warning_amber_rounded),
              label: const Text('Force Cleanup (Admin Only)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
                shadowColor: Colors.red.withOpacity(0.3),
              ),
              onPressed: _isForceCleanupLoading ? null : _triggerForceCleanup,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 0),
            child: Text(
              'This will immediately force a cleanup of all expired announcements. Use with caution.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (_forceCleanupMsg != null) ...[
            const SizedBox(height: 8),
            Center(child: Text(_forceCleanupMsg!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
          ],
        ],
      ),
    );
  }
}

class _ExpiringAnnouncementTile extends StatelessWidget {
  final Map<String, dynamic> announcement;
  const _ExpiringAnnouncementTile({required this.announcement});

  @override
  Widget build(BuildContext context) {
    final title = announcement['title'] ?? 'Announcement';
    final expirationDate = announcement['expirationDate'];
    final daysUntilExpiration = announcement['daysUntilExpiration'];
    final isExpiringSoon = announcement['isExpiringSoon'] == true;
    final isExpired = announcement['isExpired'] == true;
    return ListTile(
      leading: Icon(
        Icons.announcement,
        color: isExpired
            ? Colors.grey
            : isExpiringSoon
                ? Colors.orange
                : Colors.blue,
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expirationDate != null)
            Text('Expires: $expirationDate'),
          if (daysUntilExpiration != null)
            Text('Days left: $daysUntilExpiration'),
          if (isExpired)
            const Text('Expired', style: TextStyle(color: Colors.red)),
        ],
      ),
      trailing: isExpiringSoon && !isExpired
          ? const Icon(Icons.warning, color: Colors.orange)
          : null,
    );
  }
}
