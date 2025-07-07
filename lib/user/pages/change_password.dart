import 'package:flutter/material.dart';
import '../../services/auth_services.dart';

class ChangePasswordPage extends StatefulWidget {
  final String userId;
  const ChangePasswordPage({super.key, required this.userId});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  final AuthService _authService = AuthService();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  Future<void> _changePassword() async {
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    try {
      final result = await _authService.changePassword(
        userId: widget.userId,
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      if (result['success'] == true) {
        setState(() {
          _successMessage = result['message'] ?? 'Password changed successfully.';
        });
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      } else {
        setState(() {
          _errorMessage = result['error'] ?? 'Failed to change password.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, {Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF232323),
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      prefixIconColor: Colors.grey[400],
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Centered icon and title
              Column(
                children: const [
                  Icon(Icons.lock_reset, color: Color(0xFF6C63FF), size: 48),
                  SizedBox(height: 10),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      color: Color(0xFF6C63FF),
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Update your password to keep your account secure.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 28),
              // Card-style form
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF232323),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: !_showCurrent,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'Current password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showCurrent ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () => setState(() => _showCurrent = !_showCurrent),
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Enter your current password' : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: !_showNew,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'New password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showNew ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () => setState(() => _showNew = !_showNew),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Enter a new password';
                          if (value.length < 6) return 'Password must be at least 6 characters';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: !_showConfirm,
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration(
                          'Confirm new password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showConfirm ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey[400],
                            ),
                            onPressed: () => setState(() => _showConfirm = !_showConfirm),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Confirm your new password';
                          if (value != _newPasswordController.text) return 'Passwords do not match';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _errorMessage != null
                            ? Container(
                                key: const ValueKey('error'),
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.red[400]!.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _errorMessage!,
                                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : _successMessage != null
                                ? Container(
                                    key: const ValueKey('success'),
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green[400]!.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _successMessage!,
                                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink(),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _changePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '© 2025 NeighborHub. All rights reserved.',
                  style: TextStyle(color: Colors.white24, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 