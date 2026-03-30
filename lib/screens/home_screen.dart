import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text('Smart Campus Navigator', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_rounded)),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello, Student!', style: TextStyle(color: Colors.grey)),
            const Text('Alex Johnson', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            // Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Main Library', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text('Next Class: CS101', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => Navigator.pushNamed(context, '/map'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF2F80ED),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Get Directions'),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.book_online_rounded, size: 80, color: Colors.white24),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                _buildQuickCard(context, Icons.map_outlined, 'Campus Map', '/map'),
                _buildQuickCard(context, Icons.search_outlined, 'Search Location', '/search'),
                _buildQuickCard(context, Icons.emergency_outlined, 'Emergency Help', '/emergency', color: Colors.red),
                _buildQuickCard(context, Icons.person_outline, 'Profile', '/profile'),
              ],
            ),
            
            const SizedBox(height: 32),
            const Text('Personalized Suggestions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildSuggestionCard('Student Union', '200m away', Icons.people_outline),
            _buildSuggestionCard('Computer Lab 3', '450m away', Icons.computer_outlined),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          switch (i) {
            case 0: break; // Already Home
            case 1: Navigator.pushNamed(context, '/map'); break;
            case 2: Navigator.pushNamed(context, '/search'); break;
            case 3: Navigator.pushNamed(context, '/emergency'); break;
            case 4: Navigator.pushNamed(context, '/profile'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildQuickCard(BuildContext context, IconData icon, String label, String route, {Color color = const Color(0xFF2F80ED)}) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String name, String dist, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
          child: Icon(icon, color: const Color(0xFF2F80ED), size: 20),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(dist),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
