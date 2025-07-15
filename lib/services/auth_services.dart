import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class AuthService {
  static const String baseUrl = ApiConfig.authBaseUrl;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;

  // Add this method to set the token
  void setToken(String token) {
    _token = token;
  }

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
    try {
      print('Changing password for user: $userId');
      print('Using endpoint: ${ApiConfig.userBaseUrl}/$userId');
      print('Token present: ${_token != null}');
      
      final response = await http.put(
        Uri.parse('${ApiConfig.userBaseUrl}/$userId'), // Use the correct endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
        body: jsonEncode({
          'password': newPassword, // Only send the new password
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check if response is HTML (error page)
      if (response.body.trim().startsWith('<!DOCTYPE html>') || 
          response.body.trim().startsWith('<html>')) {
        return {
          'success': false,
          'error': 'API endpoint not found. Please check if the user endpoint exists.',
        };
      }

      // Try to parse JSON response
      dynamic data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'error': 'Invalid server response. Expected JSON but got: ${response.body.substring(0, 100)}...',
        };
      }
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Password changed successfully',
        };
      } else {
        return {
          'success': false,
          'error': data['error'] ?? data['message'] ?? 'Failed to change password',
        };
      }
    } catch (e) {
      print('Exception in changePassword: $e');
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }
}
