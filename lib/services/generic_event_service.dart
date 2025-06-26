import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EventService {
  static const String baseUrl = 'http://192.168.1.6:3000/api/events';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String time,
  }) async {
    final token = await _storage.read(key: 'jwt_token');
    final response = await http.post(
      Uri.parse(baseUrl),
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
      throw Exception('Failed to create event: \\${response.body}');
    }
  }
} 