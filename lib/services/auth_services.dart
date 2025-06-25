import 'dart:convert';
import 'package:http/http.dart' as http;

// AuthService: Handles authentication and HTTP requests to backend endpoints for login and registration.
// Integrates with /api/auth/login and /api/auth/register
class AuthService {
  static const String baseUrl = 'http://192.168.1.6:3000/api/auth'; // Change to your backend URL if needed
  String? _token;

  String? get token => _token;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      _token = data['token'];
      return data;
    } else {
      throw Exception(data['error'] ?? 'Login failed');
    }
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      _token = data['token'];
      return data;
    } else {
      throw Exception(data['error'] ?? 'Registration failed');
    }
  }

  void logout() {
    _token = null;
  }
}
