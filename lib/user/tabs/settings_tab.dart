import 'package:flutter/material.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Settings and privacy',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Account',
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
                  ),
                  _SettingsTile(
                    icon: Icons.lock,
                    title: 'Privacy',
                  ),
                  _SettingsTile(
                    icon: Icons.shield,
                    title: 'Security & permissions',
                  ),
                  _SettingsTile(
                    icon: Icons.account_circle,
                    title: 'Logout',
                    isLast: true,
                  ),
                ],
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
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.isLast = false,
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
          trailing: const Icon(Icons.chevron_right, color: Colors.white),
          onTap: () {}, // No function
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