import 'package:flutter/material.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2F80ED)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Design Document', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interactive Design Document',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F80ED)),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Placeholder for design document content.',
                    style: TextStyle(fontSize: 16, height: 1.5, color: Colors.black87),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'To upload and display your own document, you can:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Replace this exact `Container` widget with a custom `FutureBuilder` that loads a string.\n'
                    '2. Add a text or markdown file to your `assets/` directory (e.g., `assets/design_document.txt`).\n'
                    '3. Update `pubspec.yaml` to include the asset.\n'
                    '4. Load it here using `rootBundle.loadString(\'assets/design_document.txt\')`.\n'
                    '\nAlternatively, fetch it from Firebase or an external API for direct live updates without App updates.',
                    style: TextStyle(fontSize: 14, height: 1.5, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        onTap: (i) {
          switch (i) {
            case 0: Navigator.pushReplacementNamed(context, '/home'); break;
            case 1: Navigator.pushNamed(context, '/map'); break;
            case 2: Navigator.pushNamed(context, '/search'); break;
            case 3: Navigator.pushNamed(context, '/help'); break;
            case 4: break;
            case 5: Navigator.pushNamed(context, '/profile'); break;
          }
        },
                items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback_outlined), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.description_outlined), label: 'Design Doc'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
