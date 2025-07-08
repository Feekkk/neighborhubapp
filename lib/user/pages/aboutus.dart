import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF181A20),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              padding: const EdgeInsets.only(top: 80, bottom: 48, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF232526)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/img/NeighborHub.png',
                        fit: BoxFit.contain,
                        height: 56,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'NeighborHub',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connecting Communities, Empowering Neighbors.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 17,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Vision & Mission
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionHeader(
                    icon: Icons.visibility,
                    title: 'Our Vision',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'To foster safer, more connected, and empowered neighborhoods through technology.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 24),
                  _SectionHeader(
                    icon: Icons.flag,
                    title: 'Our Mission',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'NeighborHub bridges residents, admins, and emergency services, making it easy to report issues, stay informed, and build a thriving community.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Features Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(
                    icon: Icons.star,
                    title: 'Key Features',
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: const [
                        SizedBox(
                          width: 160,
                          child: _FeatureCard(
                            icon: Icons.report,
                            title: 'Incident Reporting',
                            desc: 'Quickly report emergencies or issues to admins.',
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: _FeatureCard(
                            icon: Icons.notifications_active,
                            title: 'Instant Alerts',
                            desc: 'Receive real-time notifications for important updates.',
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: _FeatureCard(
                            icon: Icons.map,
                            title: 'Location Services',
                            desc: 'Share your location for faster emergency response.',
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: _FeatureCard(
                            icon: Icons.group,
                            title: 'Community Events',
                            desc: 'Stay updated and participate in local events.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Technologies Used
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(icon: Icons.code, title: 'Technologies'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _TechIcon(
                        icon: Icons.flutter_dash,
                        label: 'Flutter',
                      ),
                      _TechIcon(
                        icon: Icons.cloud,
                        label: 'Digital Ocean',
                      ),
                      _TechIcon(
                        icon: Icons.map,
                        label: 'Google Maps',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Contribution
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SectionHeader(
                    icon: Icons.volunteer_activism,
                    title: 'Contribute & Feedback',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'We welcome your feedback and suggestions! Help us improve by reporting bugs, suggesting features, or sharing NeighborHub with your community.',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Team Member
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionHeader(icon: Icons.person, title: 'Developer'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/25/25231.png',
                        ),
                        backgroundColor: Colors.white12,
                      ),
                      const SizedBox(width: 18),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Wan Afiq',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Solo Developer',
                            style: TextStyle(color: Colors.white70, fontSize: 15),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Contact: afiqd503@gmail.com',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                '© 2025 NeighborHub. All rights reserved.',
                style: const TextStyle(color: Colors.white24, fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),
          ],
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
        Icon(icon, color: const Color(0xFF6C63FF), size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF6C63FF),
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;
  const _FeatureCard({required this.icon, required this.title, required this.desc});
  @override
  Widget build(BuildContext context) {
    return Container(
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
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Color(0xFF6C63FF), size: 32),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TechIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _TechIcon({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF232323),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ],
    );
  }
}
