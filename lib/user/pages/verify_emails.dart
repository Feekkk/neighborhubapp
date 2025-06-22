import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailsPage extends StatefulWidget {
  const VerifyEmailsPage({super.key});

  @override
  State<VerifyEmailsPage> createState() => _VerifyEmailsPageState();
}

class _VerifyEmailsPageState extends State<VerifyEmailsPage> {
  bool _isLoading = false;
  bool _isEmailSent = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = FirebaseAuth.instance.currentUser?.email;
  }

  Future<void> _sendVerificationEmail() async {
    setState(() => _isLoading = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        setState(() => _isEmailSent = true);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Verification email sent successfully!',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error sending verification email: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkVerificationStatus() async {
    setState(() => _isLoading = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;
        
        if (updatedUser?.emailVerified == true) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Email verified successfully!',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            Navigator.of(context).pop();
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Email not verified yet. Please check your inbox.',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error checking verification status: ${e.toString()}',
              style: const TextStyle(fontFamily: 'Poppins'),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text(
          'Email Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Main Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF6C63FF).withOpacity(0.2),
                    const Color(0xFFB06AB3).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.mark_email_unread_outlined,
                color: Color(0xFF6C63FF),
                size: 64,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Verify Your Email',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Email Display
            if (_userEmail != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF6C63FF).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF6C63FF),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _userEmail!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            
            // Description
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Why Verify Your Email?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem(
                    Icons.security,
                    'Enhanced Security',
                    'Protect your account from unauthorized access',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.notifications_active,
                    'Important Updates',
                    'Receive notifications about community events and announcements',
                  ),
                  const SizedBox(height: 12),
                  _buildFeatureItem(
                    Icons.verified_user,
                    'Full Access',
                    'Unlock all features of NeighborHub',
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.blue.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'How to Verify:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInstructionStep('1', 'Click "Send Verification Email" below'),
                  _buildInstructionStep('2', 'Check your email inbox (and spam folder)'),
                  _buildInstructionStep('3', 'Click the verification link in the email'),
                  _buildInstructionStep('4', 'Return to the app and click "Check Status"'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Buttons
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendVerificationEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.send, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                _isEmailSent ? 'Resend Verification Email' : 'Send Verification Email',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _checkVerificationStatus,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6C63FF),
                      side: const BorderSide(color: Color(0xFF6C63FF)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6C63FF)),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Check Verification Status',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF6C63FF),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.grey[300],
                fontSize: 14,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
