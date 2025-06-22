import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../pages/verify_emails.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? username;
  Timer? _timer;
  late DateTime _now;
  bool _hasShownVerificationDialog = false;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _startTimer();
    _loadUsername();
    _checkEmailVerification();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadUsername() async {
    if (!mounted) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      
      if (mounted) {
        setState(() {
          username = doc.data()?['username'] ?? 'user';
        });
      }
    } catch (e) {
      debugPrint('Error loading username: $e');
    }
  }

  Future<void> _checkEmailVerification() async {
    // Wait a bit for the UI to load first
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified && !_hasShownVerificationDialog) {
      // Reload user to get latest verification status
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;
      
      if (updatedUser != null && !updatedUser.emailVerified && mounted) {
        _hasShownVerificationDialog = true;
        _showEmailVerificationDialog();
      }
    }
  }

  void _showEmailVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: const Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                const Text(
                  'Email Verification Required',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                
                // Message
                Text(
                  'Please verify your email address to access all features of NeighborHub. This helps us maintain a secure community.',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VerifyEmailsPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6C63FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timeString = DateFormat('HH:mm:ss').format(_now);
    return SingleChildScrollView(
      child: Column(
        children: [
          // Welcome Card
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFB06AB3), Color(0xFF4568DC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome, ${username ?? 'user'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        timeString,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Quick Actions Card
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('d MMMM yyyy').format(_now),
                          style: const TextStyle(
                            color: Color(0xFF4568DC),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '|',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'NeighborHub',
                          style: const TextStyle(
                            color: Color(0xFFB06AB3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    // Quick Actions Grid
                    GridView.count(
                      crossAxisCount: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 8,
                      children: const [
                        _QuickAction(icon: Icons.report_problem, label: 'Report Issue', color: Color(0xFF6C63FF)),
                        _QuickAction(icon: Icons.newspaper, label: 'News', color: Color(0xFFB06AB3)),
                        _QuickAction(icon: Icons.event, label: 'Events', color: Color(0xFF4568DC)),
                        _QuickAction(icon: Icons.home_repair_service, label: 'Services', color: Color(0xFFFFD600)),
                        _QuickAction(icon: Icons.people, label: 'Community', color: Color(0xFF00BFAE)),
                        _QuickAction(icon: Icons.chat, label: 'Chat', color: Color(0xFF00B0FF)),
                        _QuickAction(icon: Icons.book, label: 'Guides', color: Color(0xFF8D6E63)),
                        _QuickAction(icon: Icons.more_horiz, label: 'More', color: Color(0xFFBDBDBD)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF232323),
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
