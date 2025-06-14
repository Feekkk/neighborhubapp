import 'package:firebase_auth/firebase_auth.dart';

class RegisterService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? 'An error occurred during registration';
    }
  }
}
