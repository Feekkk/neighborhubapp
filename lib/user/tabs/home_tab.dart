import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../pages/view_events.dart';
import '../pages/aboutus.dart';
import '../pages/view_announcement.dart';
import 'emergency_tab.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? username = 'user';
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _startTimer();
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white,
                    Colors.grey[50]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Header Section
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFFB06AB3)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.flash_on,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            color: Color(0xFF232323),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C63FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            DateFormat('d MMM yyyy').format(_now),
                            style: const TextStyle(
                              color: Color(0xFF6C63FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Enhanced Quick Actions Grid
                    GridView.count(
                      crossAxisCount: 3,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: [
                        _EnhancedQuickAction(
                          icon: Icons.report_problem, 
                          label: 'Report Emergency', 
                          gradient: const [Color(0xFF6C63FF), Color(0xFF8B7CF6)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EmergencyTab()),
                            );
                          },
                        ),
                        _EnhancedQuickAction(
                          icon: Icons.newspaper, 
                          label: 'Announcements', 
                          gradient: const [Color(0xFFB06AB3), Color(0xFFD4A5F5)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ViewAnnouncementPage()),
                            );
                          },
                        ),
                        _EnhancedQuickAction(
                          icon: Icons.event, 
                          label: 'Events', 
                          gradient: const [Color(0xFF4568DC), Color(0xFF6B8CFF)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ViewEventsPage()),
                            );
                          },
                        ),
                        _EnhancedQuickAction(
                          icon: Icons.info_outline, 
                          label: 'About Us', 
                          gradient: const [Color(0xFFFFD600), Color(0xFFFFE55C)],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AboutUsPage()),
                            );
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Footer Section
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF6C63FF).withOpacity(0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFF6C63FF).withOpacity(0.7),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Quick access to community features',
                              style: TextStyle(
                                color: const Color(0xFF6C63FF).withOpacity(0.7),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Emergency Contacts Card
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.local_phone, color: Colors.red[400], size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Emergency Hotline',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '999 (Malaysia Emergency)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.call),
                      label: const Text('Call for Help'),
                      onPressed: () {
                        launchUrl(Uri(scheme: 'tel', path: '999'));
                      },
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

class _EnhancedQuickAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _EnhancedQuickAction({
    required this.icon,
    required this.label,
    required this.gradient,
    required this.onTap,
  });

  @override
  State<_EnhancedQuickAction> createState() => _EnhancedQuickActionState();
}

class _EnhancedQuickActionState extends State<_EnhancedQuickAction> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  Animation<double>? _opacityAnimation;
  Animation<double>? _elevationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _elevationAnimation = Tween<double>(
      begin: 12.0,
      end: 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _animationController.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final opacity = _opacityAnimation?.value ?? 1.0;
          final elevation = _elevationAnimation?.value ?? 12.0;
          return Opacity(
            opacity: opacity,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.gradient,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: widget.gradient[0].withOpacity(0.3),
                    blurRadius: elevation,
                    offset: Offset(0, _isPressed ? 2 : 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.8),
                    blurRadius: 1,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
