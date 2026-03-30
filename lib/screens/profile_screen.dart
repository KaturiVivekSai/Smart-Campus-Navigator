import 'package:flutter/material.dart';
import '../main.dart'; // To access authService

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String role = authService.currentUserRole ?? 'Guest';
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.blue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Profile', style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Header
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const Hero(
                  tag: 'profile-pic',
                  child: CircleAvatar(
                    radius: 65,
                    backgroundColor: Color(0xFF2F80ED),
                    child: CircleAvatar(
                      radius: 62,
                      backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=Alex+Johnson&background=fff&color=2F80ED&size=200'),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Color(0xFF2F80ED), shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Alex Johnson',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: textColor),
            ),
            Text(
              '$role • Computer Science Dept.',
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),

            // Profile Options
            _buildProfileItem(context, Icons.person_outline_rounded, 'Edit Profile', () => _showEditProfile(context)),
            _buildProfileItem(context, Icons.bookmark_outline_rounded, 'Saved Locations', () => _showSavedLocations(context)),
            _buildProfileItem(context, Icons.settings_outlined, 'App Settings', () => _showSettings(context)),
            _buildProfileItem(context, Icons.dark_mode_outlined, 'Appearance', () {}),
            const SizedBox(height: 12),
            const Divider(height: 40),
            
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton.icon(
                onPressed: () {
                  authService.logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        tileColor: Colors.grey[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: const Color(0xFF2F80ED)),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 32, right: 32, top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildModalField('Full Name', 'Alex Johnson'),
            const SizedBox(height: 16),
            _buildModalField('Email', 'alex.j@campus.edu'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showSavedLocations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Saved Locations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildLocationItem('Main Library', 'Block C'),
            _buildLocationItem('Computer Lab 3', 'Block A'),
            _buildLocationItem('V-Cafe', 'Near Block B'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('App Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SwitchListTile(title: const Text('Notifications'), value: true, onChanged: (v) {}),
            ListTile(title: const Text('Font Style'), subtitle: const Text('Poppins'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
            ListTile(title: const Text('Text Size'), subtitle: const Text('Default'), trailing: const Icon(Icons.chevron_right), onTap: () {}),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildModalField(String label, String value) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      ),
      controller: TextEditingController(text: value),
    );
  }

  Widget _buildLocationItem(String name, String sub) {
    return ListTile(
      leading: const Icon(Icons.location_on_rounded, color: Color(0xFF2F80ED)),
      title: Text(name),
      subtitle: Text(sub),
      onTap: () {},
    );
  }
}
