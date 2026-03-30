import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _profileImage;
  double _fontSize = 14.0;

  void _pickImage() {
    // Show a selection dialog for profile images
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose Profile Picture', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 12, mainAxisSpacing: 12),
              itemCount: 8,
              itemBuilder: (context, index) {
                final avatarUrl = 'https://i.pravatar.cc/150?img=${index + 1}';
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {});
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile picture updated!'), backgroundColor: const Color(0xFF27AE60)),
                      );
                    },
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(avatarUrl),
                      radius: 30,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Camera access requires native platform support'), backgroundColor: Color(0xFF2F80ED)),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.camera_alt_rounded, color: Color(0xFF2F80ED)),
                ),
                title: const Text('Take Photo', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gallery access requires native platform support'), backgroundColor: Color(0xFF2F80ED)),
                  );
                },
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: const Color(0xFF27AE60).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.photo_library_rounded, color: Color(0xFF27AE60)),
                ),
                title: const Text('Choose from Gallery', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String role = authService.currentUserRole ?? 'Guest';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2F80ED)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Profile', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Column(
          children: [
            // Profile Header with Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: const Color(0xFF2F80ED),
                      child: CircleAvatar(
                        radius: 66,
                        backgroundImage: const NetworkImage('https://i.pravatar.cc/150?u=smartcampus'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFF2F80ED), shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text('Tap to change photo', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            Text('Alex Johnson', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text('$role • Smart Campus Navigator', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 40),

            _buildProfileSection('Personal Information', [
              _buildHoverItem(Icons.person_outline_rounded, 'Edit Profile', () => _showEditProfile(context)),
              _buildHoverItem(Icons.bookmark_outline_rounded, 'Saved Locations', () => _showSavedLocations(context)),
            ]),
            const SizedBox(height: 24),
            _buildProfileSection('Application', [
              _buildHoverItem(Icons.settings_outlined, 'App Settings', () => _showSettings(context)),
              _buildHoverItem(Icons.info_outline_rounded, 'About Smart Campus Navigator', () {}),
            ]),
            const SizedBox(height: 48),

            SizedBox(
              width: double.infinity,
              height: 60,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: () {
                    authService.logout();
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  },
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  label: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildHoverItem(IconData icon, String title, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        hoverColor: const Color(0xFF2F80ED).withOpacity(0.04),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: const Color(0xFF2F80ED), size: 22),
          ),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 32, right: 32, top: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            _buildField('Full Name', 'Alex Johnson', Icons.person_rounded),
            const SizedBox(height: 16),
            _buildField('Email', 'alex.j@campus.edu', Icons.email_rounded),
            const SizedBox(height: 16),
            _buildField('Department', 'Computer Science', Icons.business_rounded),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F80ED), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _showSavedLocations(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Saved Locations', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildSavedItem('Library', 'Block B, Floor 1'),
            _buildSavedItem('Computer Lab 3', 'Block A, Floor 3'),
            _buildSavedItem('Cafeteria', 'Ground Floor'),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('App Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('Text Size'),
                subtitle: Slider(
                  value: _fontSize,
                  min: 12,
                  max: 24,
                  divisions: 6,
                  onChanged: (v) {
                    setModalState(() => _fontSize = v);
                    setState(() {});
                  },
                ),
                trailing: Text('${_fontSize.toInt()}px'),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String value, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2F80ED)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      controller: TextEditingController(text: value),
    );
  }

  Widget _buildSavedItem(String name, String sub) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.location_on_rounded, color: Color(0xFF2F80ED)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, '/map', arguments: name);
        },
      ),
    );
  }
}
