import 'auth_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegisterService {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Map<String, dynamic>> createUserWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      final result = await _authService.register(username, email, password);
      // Print result for debugging
      print('Register result: $result');
      // Save user ID to secure storage
if (result['user'] != null && result['user']['id'] != null) {
  await _storage.write(key: 'user_id', value: result['user']['id'].toString());
}
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.logout();
  }
}


