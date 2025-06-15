import 'package:flutter/material.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Guidelines', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
                  ),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.menu_book_rounded,
                        size: 48,
                        color: Color(0xFF6C63FF),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Admin Guidelines',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Learn how to effectively manage NeighborHub',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // User Management Section
              _buildSection(
                'User Management',
                Icons.people,
                [
                  _buildGuidelineItem(
                    'View Users',
                    'Access the Users tab to view all registered users. You can see their basic information and account status.',
                  ),
                  _buildGuidelineItem(
                    'User Verification',
                    'Verify new user accounts by checking their submitted documents and information.',
                  ),
                  _buildGuidelineItem(
                    'Account Actions',
                    'You can suspend, delete, or modify user accounts based on community guidelines violations.',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Community Management Section
              _buildSection(
                'Community Management',
                Icons.groups,
                [
                  _buildGuidelineItem(
                    'Monitor Posts',
                    'Review and moderate community posts to ensure they follow guidelines.',
                  ),
                  _buildGuidelineItem(
                    'Handle Reports',
                    'Address user reports about inappropriate content or behavior.',
                  ),
                  _buildGuidelineItem(
                    'Announcements',
                    'Create and manage community-wide announcements for important updates.',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Security & Privacy Section
              _buildSection(
                'Security & Privacy',
                Icons.security,
                [
                  _buildGuidelineItem(
                    'Data Protection',
                    'Ensure all user data is handled according to privacy policies.',
                  ),
                  _buildGuidelineItem(
                    'Access Control',
                    'Manage admin access levels and permissions carefully.',
                  ),
                  _buildGuidelineItem(
                    'Security Monitoring',
                    'Regularly monitor for suspicious activities and security breaches.',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // System Management Section
              _buildSection(
                'System Management',
                Icons.settings,
                [
                  _buildGuidelineItem(
                    'App Settings',
                    'Configure system-wide settings and preferences.',
                  ),
                  _buildGuidelineItem(
                    'Backup & Recovery',
                    'Regularly backup system data and know recovery procedures.',
                  ),
                  _buildGuidelineItem(
                    'Updates & Maintenance',
                    'Schedule and manage system updates and maintenance.',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Best Practices Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.lightbulb,
                          color: Color(0xFF6C63FF),
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Best Practices',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBestPracticeItem('Always verify information before taking action'),
                    _buildBestPracticeItem('Maintain detailed logs of all administrative actions'),
                    _buildBestPracticeItem('Respond to user concerns promptly and professionally'),
                    _buildBestPracticeItem('Regularly review and update community guidelines'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Footer
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

  Widget _buildSection(String title, IconData icon, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: const Color(0xFF6C63FF), size: 24),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildGuidelineItem(String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestPracticeItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF6C63FF),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
