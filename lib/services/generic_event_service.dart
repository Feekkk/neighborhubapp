import 'dart:convert';
import 'package:http/http.dart' as http;

class EventService {
  static const String baseUrl = 'http://192.168.1.6:3000/api/events';

  Future<void> createEvent({
    required String title,
    required String description,
    required DateTime date,
    required String time,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'description': description,
        'date': date.toIso8601String(),
        'time': time,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create event: \\${response.body}');
    }
  }
} 