import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during sign in';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
