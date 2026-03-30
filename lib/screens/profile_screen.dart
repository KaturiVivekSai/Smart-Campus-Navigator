import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFF2F80ED),
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Vivek Sai',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text('Student ID: SC20260456', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
            _buildInfoCard(
              context,
              'Personal Info',
              [
                _buildInfoItem(Icons.email_outlined, 'Email', 'viveksai@campus.edu'),
                _buildInfoItem(Icons.phone_outlined, 'Phone', '+91 98765 43210'),
                _buildInfoItem(Icons.school_outlined, 'Department', 'Computer Science'),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoCard(
              context,
              'Account Settings',
              [
                _buildInfoItem(Icons.notifications_outlined, 'Notifications', 'Enabled'),
                _buildInfoItem(Icons.lock_outline, 'Privacy', 'Manage Security'),
                _buildInfoItem(Icons.logout, 'Logout', 'Sign out of account', color: Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            ...items,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color(0xFF2F80ED)),
      title: Text(label),
      subtitle: Text(value),
      contentPadding: EdgeInsets.zero,
      onTap: () {},
    );
  }
}
