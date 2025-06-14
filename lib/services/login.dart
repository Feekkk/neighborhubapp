import 'package:firebase_auth/firebase_auth.dart';
import 'package:neighborhub/services/admin_service.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Check if it's the admin account
      if (email == AdminService.adminEmail && password == AdminService.adminPassword) {
        // Try to sign in with admin credentials
        return await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        // For non-admin users, proceed with normal login
        return await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during sign in';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
