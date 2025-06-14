import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:neighborhub/user/tabs/home_tab.dart';
import 'package:neighborhub/user/tabs/emergency_tab.dart';
import 'package:neighborhub/user/tabs/timetable_tab.dart';
import 'package:neighborhub/user/tabs/settings_tab.dart';

class DashboardUser extends StatefulWidget {
  const DashboardUser({Key? key}) : super(key: key);

  @override
  State<DashboardUser> createState() => _DashboardUserState();
}

class _DashboardUserState extends State<DashboardUser> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D2D2D),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeTab(),
          EmergencyTab(),
          TimetableTab(),
          SettingsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF6C63FF),
          indicatorWeight: 2,
          labelColor: const Color(0xFF6C63FF),
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
          ),
          tabs: [
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.home_rounded, size: 22),
              ),
              text: 'Home',
            ),
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_rounded, size: 22),
              ),
              text: 'Emergency',
            ),
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.calendar_today_rounded, size: 22),
              ),
              text: 'Timetable',
            ),
            Tab(
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.settings_rounded, size: 22),
              ),
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
