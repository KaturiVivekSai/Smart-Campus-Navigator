import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  int currentFloor = 1;
  bool isNavigating = false;
  bool showPath = false;
  bool _hasCheckedArgs = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        if (args.toLowerCase().contains('computer')) {
          setState(() {
            currentFloor = 3;
            showPath = true;
          });
        }
      }
      _hasCheckedArgs = true;
    }
  }

  void _startNavigation() {
    setState(() {
      isNavigating = true;
      showPath = true;
    });
  }

  void _stopNavigation() {
    setState(() {
      isNavigating = false;
      showPath = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Campus Map Surface
          GestureDetector(
            onPanUpdate: (details) => setState(() {}),
            child: CustomPaint(
              size: MediaQuery.of(context).size,
              painter: CampusMapPainter(
                floor: currentFloor, 
                showPath: showPath,
                isNavigating: isNavigating,
              ),
            ),
          ),

          // Top Search Bar (Only when not in active navigation)
          if (!isNavigating)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20,
              right: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    if (val.toLowerCase().contains('computer')) {
                      setState(() => showPath = true);
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Buildings, Labs...',
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF2F80ED)),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF2F80ED)), onPressed: () {}),
                        IconButton(icon: const Icon(Icons.volume_up_rounded, color: Colors.grey), onPressed: () {}),
                      ],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),

          // Floor Switcher
          Positioned(
            right: 20,
            top: MediaQuery.of(context).size.height * 0.35,
            child: Column(
              children: [3, 2, 1].map((f) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: FloatingActionButton.small(
                  heroTag: 'f$f',
                  onPressed: () => setState(() => currentFloor = f),
                  backgroundColor: currentFloor == f ? const Color(0xFF2F80ED) : Colors.white,
                  child: Text(
                    'F$f', 
                    style: TextStyle(
                      color: currentFloor == f ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
              )).toList(),
            ),
          ),

          // Navigation Status Overlay
          if (showPath && !isNavigating)
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20)],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ListTile(
                      leading: Icon(Icons.computer_rounded, color: Color(0xFF2F80ED), size: 32),
                      title: Text('Computer Lab 3', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Floor 3 • Block A • 120m away'),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _startNavigation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Start Navigating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Active Navigation View (No Bottom Nav)
          if (isNavigating)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10, bottom: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF2F80ED),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white),
                      onPressed: _stopNavigation,
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Turn Left toward Block A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('Arrival in 2 mins', style: TextStyle(color: Colors.white70, fontSize: 14)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

          // Back to Home Button (Only if not navigating)
          if (!isNavigating)
            Positioned(
              bottom: 40,
              left: 20,
              child: FloatingActionButton.small(
                heroTag: 'back',
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.white,
                child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isNavigating ? null : BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2F80ED),
        unselectedItemColor: Colors.grey,
        onTap: (i) {
          switch (i) {
            case 0: Navigator.pushReplacementNamed(context, '/home'); break;
            case 1: break;
            case 2: Navigator.pushNamed(context, '/search'); break;
            case 3: Navigator.pushNamed(context, '/emergency'); break;
            case 4: Navigator.pushNamed(context, '/profile'); break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services_outlined), label: 'Help'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}

class CampusMapPainter extends CustomPainter {
  final int floor;
  final bool showPath;
  final bool isNavigating;

  CampusMapPainter({required this.floor, required this.showPath, required this.isNavigating});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.fill;

    // Draw Background
    canvas.drawRect(Offset.zero & size, paint);

    // Draw Buildings (Simulated)
    final blockAPaint = Paint()..color = const Color(0xFF2F80ED).withOpacity(0.15);
    final blockBPaint = Paint()..color = Colors.green.withOpacity(0.1);
    final blockCPaint = Paint()..color = Colors.orange.withOpacity(0.1);

    // Block A (Admin & Labs)
    canvas.drawRRect(RRect.fromLTRBR(60, 200, 180, 400, const Radius.circular(20)), blockAPaint);
    _drawLabel(canvas, const Offset(120, 300), "Block A\n(Admin/Labs)");

    // Block B (Classrooms)
    canvas.drawRRect(RRect.fromLTRBR(220, 150, 340, 300, const Radius.circular(20)), blockBPaint);
    _drawLabel(canvas, const Offset(280, 225), "Block B\n(Classrooms)");

    // Block C (Library)
    canvas.drawRRect(RRect.fromLTRBR(100, 500, 300, 650, const Radius.circular(20)), blockCPaint);
    _drawLabel(canvas, const Offset(200, 575), "Block C\n(Library)");

    // Computer Lab 3 (Special Highlight if on Floor 3)
    if (floor == 3) {
      final labPaint = Paint()..color = const Color(0xFF2F80ED)..style = PaintingStyle.fill;
      canvas.drawCircle(const Offset(120, 250), 10, labPaint);
      _drawLabel(canvas, const Offset(120, 230), "Computer Lab 3", color: const Color(0xFF2F80ED));
    }

    // Current User Position
    final userPaint = Paint()..color = Colors.blue;
    canvas.drawCircle(const Offset(250, 750), 8, userPaint);
    canvas.drawCircle(const Offset(250, 750), 20, userPaint..color = Colors.blue.withOpacity(0.2));

    // Green Path Navigation
    if (showPath) {
      final pathPaint = Paint()
        ..color = Colors.green
        ..strokeWidth = 5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(250, 750); // Start
      path.lineTo(250, 450); // Mid 1
      path.lineTo(120, 450); // Mid 2
      path.lineTo(120, 300); // End Block A Entrance

      if (floor == 3) {
        path.lineTo(120, 250); // To Lab on Floor 3
      }

      // Draw shadow for path
      canvas.drawPath(path, Paint()..color = Colors.green.withOpacity(0.2)..strokeWidth = 8..style = PaintingStyle.stroke);
      canvas.drawPath(path, pathPaint);
    }
  }

  void _drawLabel(Canvas canvas, Offset offset, String text, {Color color = Colors.grey}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text, 
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CampusMapPainter oldDelegate) => 
    oldDelegate.floor != floor || oldDelegate.showPath != showPath || oldDelegate.isNavigating != isNavigating;
}
