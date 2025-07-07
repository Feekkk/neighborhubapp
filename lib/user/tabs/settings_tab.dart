import 'package:flutter/material.dart';
import 'package:neighborhub/user/pages/edit_profile.dart';
import 'package:neighborhub/user/pages/aboutus.dart';
import 'package:neighborhub/user/pages/change_password.dart';
import '../../services/user_service.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String? _username;
  String? _email;
  String? _userId;
  bool _isLoading = true;
  final UserService _userService = UserService();
  
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userId = await _userService.getUserIdFromStorage();
      if (userId == null) throw Exception('User ID not found');
      final user = await _userService.getUserProfile(userId);
      setState(() {
        _userId = userId;
        _username = user['username'] ?? '';
        _email = user['email'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Profile section
            Center(
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 340,
                          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF232323), Color(0xFF1A1A1A)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: const CircleAvatar(
                                      radius: 48,
                                      backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/340px-Default_pfp.svg.png?20220226140232'),
                                      backgroundColor: Colors.black,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0xFF6C63FF),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 2),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(3.0),
                                        child: Icon(Icons.edit, size: 16, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),
                              Text(
                                _username ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  fontFamily: 'Poppins',
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email_outlined, color: Colors.grey[400], size: 18),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      _email ?? '',
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 15,
                                        fontFamily: 'Poppins',
                                      ),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Settings',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF232323),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
              child: Column(
                children: [
                  _SettingsTile(
                    icon: Icons.person,
                    title: 'Account',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfilePage()),
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Change Password',
                    onTap: () {
                      if (_userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage(userId: _userId!)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User ID not loaded. Please try again.')),
                        );
                      }
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutUsPage()),
                      );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    isLast: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                '\u00a9 2025 NeighborHub. All rights reserved.',
                style: const TextStyle(color: Colors.white24, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.isLast = false,
    this.onTap, this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey[300]),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle!,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontFamily: 'Poppins',
                  ),
                )
              : null,
          trailing: const Icon(Icons.chevron_right, color: Colors.white),
          onTap: onTap,
        ),
        if (!isLast)
          const Divider(
            color: Color(0xFF353535),
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
} 