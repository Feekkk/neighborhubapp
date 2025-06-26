import 'auth_services.dart';

class RegisterService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> createUserWithEmailAndPassword(
      String username, String email, String password) async {
    try {
      final result = await _authService.register(username, email, password);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.logout();
  }
}


