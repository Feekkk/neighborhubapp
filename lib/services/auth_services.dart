import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class AuthService {
  static const String baseUrl = ApiConfig.authBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['token'] != null) {
      _token = data['token'];
      await _storage.write(key: 'jwt_token', value: _token);
      await _storage.write(key: 'user_id', value: data['userId']);
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
      await _storage.write(key: 'jwt_token', value: _token);
      await _storage.write(key: 'user_id', value: data['userId']);
      return data;
    } else {
      throw Exception(data['error'] ?? 'Registration failed');
    }
  }

  Future<String?> getStoredToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'jwt_token');
  }

  Future<Map<String, dynamic>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await http.put(
      Uri.parse(ApiConfig.changePasswordUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      }),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
