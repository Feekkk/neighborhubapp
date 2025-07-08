import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class EventService {
  static final String eventBaseUrl = ApiConfig.eventBaseUrl;
  static final String announcementBaseUrl = ApiConfig.announcementBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<dynamic>> fetchEvents() async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.get(
      Uri.parse(eventBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    } else {
      throw Exception('Failed to fetch events: ${response.statusCode}');
    }
  }

  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String time,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse(eventBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'date': date.toUtc().toIso8601String(),
        'time': time,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create event: ${response.body}');
    }
  }

  Future<void> createAnnouncement({
    required String title,
    required String description,
    required String priority,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse(announcementBaseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'description': description,
        'priority': priority,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create announcement: ${response.body}');
    }
  }
}

class EmergencyReportService {
  static const String baseUrl = 'http://146.190.85.190/api/reports';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getAuthToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<List<dynamic>> fetchAllReports({String status = 'OPEN'}) async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    final uri = status == 'ALL'
        ? Uri.parse(baseUrl)
        : Uri.parse('$baseUrl?status=$status');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized: Please login again');
    } else {
      throw Exception('Failed to fetch emergency reports: \\${response.statusCode}');
    }
  }

  Future<List<dynamic>> fetchAllReportsForPdf() async {
    return fetchAllReports(status: 'ALL');
  }

  Future<void> resolveEmergency(String reportId) async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }

    final response = await http.patch(
      Uri.parse('$baseUrl/$reportId/resolve'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'resolvedAt': DateTime.now().toUtc().toIso8601String(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to resolve emergency: ${response.statusCode}');
    }
  }

  Future<void> updateReportStatus(String reportId, String status) async {
    final token = await _getAuthToken();
    if (token == null) {
      throw Exception('Authentication token not found');
    }
    final response = await http.put(
      Uri.parse('http://146.190.85.190/api/admin/reports/$reportId/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'status': status,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update report status: ${response.statusCode}');
    }
  }
} 