import 'package:firebase_auth/firebase_auth.dart';

class AdminService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hardcoded admin credentials
  static const String adminEmail = 'admin@gmail.com';
  static const String adminPassword = 'admin123';

  // Check if the current user is an admin
  Future<bool> isAdmin() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Check if the current user's email matches the admin email
      return user.email == adminEmail;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  // Set a user as admin (disabled since we're using hardcoded admin)
  Future<void> setUserAsAdmin(String userId) async {
    throw Exception('Admin account is hardcoded and cannot be modified');
  }

  // Remove admin role (disabled since we're using hardcoded admin)
  Future<void> removeAdminRole(String userId) async {
    throw Exception('Admin account is hardcoded and cannot be modified');
  }
} 