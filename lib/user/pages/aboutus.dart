import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Description
              Center(
                child: Column(
                  children: [
                    Icon(Icons.verified_user, color: Theme.of(context).primaryColor, size: 48),
                    const SizedBox(height: 10),
                    Text(
                      'NeighborHub',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connecting Communities, Empowering Neighbors.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // Regulations & Consent
              _SectionHeader(icon: Icons.privacy_tip, title: 'User Consent & Regulations'),
              _CardSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'By using NeighborHub, you agree to:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    _Bullet(text: 'Your data (profile, location, reports) is stored securely and only used for community features.'),
                    _Bullet(text: 'Emergencies and reports are visible to admins for your safety.'),
                    _Bullet(text: 'You consent to receive notifications for important community updates.'),
                    _Bullet(text: 'You agree to use the app respectfully and not misuse emergency features.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Contribution
              _SectionHeader(icon: Icons.volunteer_activism, title: 'Contribution'),
              _CardSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'NeighborHub is open for feedback and suggestions! You can contribute by:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    _Bullet(text: 'Reporting bugs or issues via the app.'),
                    _Bullet(text: 'Suggesting new features or improvements.'),
                    _Bullet(text: 'Sharing the app with your community.'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Technologies Used
              _SectionHeader(icon: Icons.code, title: 'Technologies Used'),
              _CardSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TechRow(icon: Icons.flutter_dash, name: 'Flutter (UI Framework)'),
                    _TechRow(icon: Icons.cloud, name: 'Firebase (Auth, Firestore, Cloud Functions)'),
                    _TechRow(icon: Icons.map, name: 'Google Maps (Emergency Location)'),
                    _TechRow(icon: Icons.notifications, name: 'Push Notifications'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Team Member
              _SectionHeader(icon: Icons.person, title: 'Team Member'),
              _CardSection(
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/solo_dev.png'), // Replace with your own asset or use NetworkImage
                      backgroundColor: Colors.white12,
                    ),
                    const SizedBox(width: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Afiq', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(height: 4),
                        Text('Solo Developer', style: TextStyle(color: Colors.white70, fontSize: 15)),
                        SizedBox(height: 2),
                        Text('Contact: afiq@example.com', style: TextStyle(color: Colors.white54, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  '© 2024 NeighborHub. All rights reserved.',
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class _CardSection extends StatelessWidget {
  final Widget child;
  const _CardSection({required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.white, fontSize: 16)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class _TechRow extends StatelessWidget {
  final IconData icon;
  final String name;
  const _TechRow({required this.icon, required this.name});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 15)),
        ],
      ),
    );
  }
}
