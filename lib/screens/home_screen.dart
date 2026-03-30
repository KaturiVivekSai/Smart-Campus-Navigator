import 'package:flutter/material.dart';
import '../main.dart'; // To access authService

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String role = authService.currentUserRole ?? 'Guest';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Smart Campus',
          style: TextStyle(color: Color(0xFF2F80ED), fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile'),
              child: const Hero(
                tag: 'profile-pic',
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF2F80ED),
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=smartcampus'),
                ),
              ),
            ),
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $role!',
                style: const TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const Text(
                'Campus Explorer',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              
              // Hero Quick Navigate Card
              _buildHeroCard(context),
              
              const SizedBox(height: 32),
              const Text(
                'Quick Access',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              
              _buildQuickAccessGrid(context),
              
              const SizedBox(height: 32),
              _buildSectionHeader('Admin Office', 'Open Map', () => Navigator.pushNamed(context, '/map', arguments: 'Admin')),
              const SizedBox(height: 16),
              
              _buildActionCard(
                context,
                'Main Administration',
                'Block A, Ground Floor • 9 AM - 5 PM',
                Icons.business_rounded,
                () => _showOfficeInfo(context, 'Main Administration'),
              ),
              
              const SizedBox(height: 24),
              _buildSectionHeader('Visited Recently', 'View All', () => Navigator.pushNamed(context, '/search')),
              const SizedBox(height: 16),
              
              _buildActionCard(
                context,
                'Computer Lab 3',
                'Floor 3, Block A • Green Path Ready',
                Icons.computer_rounded,
                () => Navigator.pushNamed(context, '/map', arguments: 'Computer Lab 3'),
                isPremium: true,
              ),
              _buildActionCard(
                context,
                'Central Library',
                'Floor 1, Block C • Quiet Zone',
                Icons.menu_book_rounded,
                () => Navigator.pushNamed(context, '/map', arguments: 'Library'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/map'),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(color: const Color(0xFF2F80ED).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Interactive Navigator', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Real-time indoor campus pathfinding with floor support.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.directions_rounded, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text('Start Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.explore_rounded, size: 48, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildQuickCard(context, Icons.map_outlined, 'Campus Map', '/map'),
        _buildQuickCard(context, Icons.search_outlined, 'Search', '/search'),
        _buildQuickCard(context, Icons.emergency_outlined, 'Emergency', '/emergency', color: Colors.redAccent),
        _buildQuickCard(context, Icons.help_outline_rounded, 'Help Center', '/help'),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String action, VoidCallback onAction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        TextButton(
          onPressed: onAction,
          child: Text(action, style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 13, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }

  Widget _buildQuickCard(BuildContext context, IconData icon, String label, String route, {Color color = const Color(0xFF2F80ED)}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap, {bool isPremium = false}) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: isPremium ? const BorderSide(color: Color(0xFF2F80ED), width: 1.5) : BorderSide.none,
      ),
      color: Colors.white,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
          child: Icon(icon, color: const Color(0xFF2F80ED), size: 24),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
      child: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback_rounded), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
        onTap: (i) {
          switch (i) {
            case 0: break;
            case 1: Navigator.pushNamed(context, '/map'); break;
            case 2: Navigator.pushNamed(context, '/search'); break;
            case 3: Navigator.pushNamed(context, '/help'); break;
            case 4: Navigator.pushNamed(context, '/profile'); break;
          }
        },
      ),
    );
  }

  void _showOfficeInfo(BuildContext context, String office) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.business_rounded, color: Color(0xFF2F80ED), size: 32),
                const SizedBox(width: 16),
                Text(office, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'The Main Administration office is your hub for academic affairs, faculty coordination, and campus approvals. Located conveniently in Block A.',
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.6),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/map', arguments: 'Admin Office');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Navigate to Office', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
