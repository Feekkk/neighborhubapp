import 'auth_services.dart';

class LoginService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _authService.login(email, password);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    _authService.logout();
  }
}
