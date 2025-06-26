import 'auth_services.dart';

class LoginService {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> signInWithUsernameAndPassword(
      String username, String password) async {
    try {
      final result = await _authService.login(username, password);
      return result;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut() async {
    await _authService.logout();
  }
}
