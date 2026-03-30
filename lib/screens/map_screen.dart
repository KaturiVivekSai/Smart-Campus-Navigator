import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  int currentFloor = 1;
  bool isNavigating = false;
  bool showPath = false;
  bool _hasCheckedArgs = false;
  final TextEditingController _searchController = TextEditingController();
  
  // Simulated movement for "Start Navigating"
  double _userX = 250.0;
  double _userY = 750.0;
  late AnimationController _moveController;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    _moveController.addListener(() {
      setState(() {
        // Move user along the path
        if (_moveController.value < 0.3) {
          _userY = 750 - (300 * (_moveController.value / 0.3));
        } else if (_moveController.value < 0.6) {
          _userX = 250 - (130 * ((_moveController.value - 0.3) / 0.3));
        } else if (_moveController.value < 0.9) {
          _userY = 450 - (200 * ((_moveController.value - 0.6) / 0.3));
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        if (args.toLowerCase().contains('computer') || args.toLowerCase().contains('lab')) {
          _searchController.text = "Computer Lab 3";
          setState(() {
            currentFloor = 3;
            showPath = true;
          });
        } else if (args.toLowerCase().contains('admin')) {
          _searchController.text = "Main Admin";
          setState(() {
            currentFloor = 1;
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
    _moveController.forward(from: 0);
  }

  void _stopNavigation() {
    _moveController.stop();
    setState(() {
      isNavigating = false;
      showPath = false;
      _userX = 250.0;
      _userY = 750.0;
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _searchController.dispose();
    super.dispose();
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
                userX: _userX,
                userY: _userY,
              ),
            ),
          ),

          // Top Header (Search Bar or Navigation Instruction)
          _buildHeader(context),

          // Floor Switcher (Vertical)
          _buildFloorSwitcher(),

          // Destination Overlay (When path is found but navigation hasn't started)
          if (showPath && !isNavigating) _buildDestinationCard(),

          // Voice Guidance Button (Floating during navigation)
          if (isNavigating)
            Positioned(
              right: 20,
              bottom: 40,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: const Color(0xFF27AE60),
                child: const Icon(Icons.volume_up_rounded, color: Colors.white),
              ),
            ),

          // Back to Home Button
          if (!isNavigating)
            Positioned(
              bottom: 40,
              left: 20,
              child: FloatingActionButton.small(
                heroTag: 'back_btn',
                onPressed: () => Navigator.pop(context),
                backgroundColor: Colors.white,
                child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
              ),
            ),
        ],
      ),
      // Remove navigation bar if navigating
      bottomNavigationBar: isNavigating ? null : _buildBottomNav(context),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 20,
      right: 20,
      child: isNavigating 
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFF2F80ED),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, 5))],
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
                      Text('Turn Left at Block A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('120m • 2 mins left', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    ],
                  ),
                ),
                const Icon(Icons.turn_left_rounded, color: Colors.white, size: 36),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                if (val.toLowerCase().contains('computer') || val.toLowerCase().contains('lab')) {
                  setState(() => showPath = true);
                }
              },
              decoration: InputDecoration(
                hintText: 'Search Lab, Office, Floor...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2F80ED)),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.mic_rounded, color: Color(0xFF2F80ED)), onPressed: () {}),
                    const VerticalDivider(width: 1, indent: 10, endIndent: 10),
                    IconButton(icon: const Icon(Icons.layers_outlined, color: Colors.grey), onPressed: () {}),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
    );
  }

  Widget _buildFloorSwitcher() {
    return Positioned(
      right: 20,
      top: MediaQuery.of(context).size.height * 0.35,
      child: Column(
        children: [3, 2, 1].map((f) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              FloatingActionButton.small(
                heroTag: 'floor_$f',
                onPressed: () => setState(() => currentFloor = f),
                backgroundColor: currentFloor == f ? const Color(0xFF2F80ED) : Colors.white,
                child: Text('F$f', style: TextStyle(color: currentFloor == f ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
              ),
              if (f == 3 && currentFloor == 3) 
                const Card(
                  margin: EdgeInsets.only(top: 4),
                  child: Padding(padding: EdgeInsets.all(4), child: Icon(Icons.computer_rounded, size: 12, color: Color(0xFF2F80ED))),
                )
            ],
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildDestinationCard() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 25)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.computer_rounded, color: Color(0xFF2F80ED), size: 32),
              ),
              title: const Text('Computer Lab 3', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: const Text('Block A • Floor 3 • 120m away'),
              trailing: IconButton(
                icon: const Icon(Icons.share_location_rounded, color: Color(0xFF2F80ED)),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _startNavigation,
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                label: const Text('Start Navigating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27AE60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 1,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF2F80ED),
      onTap: (i) {
        switch (i) {
          case 0: Navigator.pushReplacementNamed(context, '/home'); break;
          case 1: break;
          case 2: Navigator.pushNamed(context, '/search'); break;
          case 3: Navigator.pushNamed(context, '/help'); break;
          case 4: Navigator.pushNamed(context, '/profile'); break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
        BottomNavigationBarItem(icon: Icon(Icons.feedback_outlined), label: 'Help'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

class CampusMapPainter extends CustomPainter {
  final int floor;
  final bool showPath;
  final bool isNavigating;
  final double userX;
  final double userY;

  CampusMapPainter({
    required this.floor, 
    required this.showPath, 
    required this.isNavigating,
    required this.userX,
    required this.userY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFFF0F4FF);
    canvas.drawRect(Offset.zero & size, bgPaint);

    final wallPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw Campus Grounds
    final grassPaint = Paint()..color = Colors.green[50]!;
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5), size.width * 0.4, grassPaint);

    // Block Layouts (Simplified)
    _drawBlock(canvas, "Block A", const Offset(60, 200), const Size(120, 250), Colors.blue[50]!);
    _drawBlock(canvas, "Block B", const Offset(220, 150), const Size(120, 200), Colors.green[50]!);
    _drawBlock(canvas, "Block C", const Offset(100, 500), const Size(200, 150), Colors.orange[50]!);

    // Floor Specific Features
    if (floor == 3) {
      // Highlight Lab 3 on 3rd Floor
      final labPaint = Paint()..color = Colors.blue[400]!..style = PaintingStyle.fill;
      canvas.drawRRect(RRect.fromLTRBR(80, 220, 160, 280, const Radius.circular(8)), labPaint);
      _drawLabel(canvas, const Offset(120, 250), "Computer Lab 3", color: Colors.white, size: 10);
    } else if (floor == 1) {
      _drawLabel(canvas, const Offset(120, 400), "Main Admin", color: Colors.blue[800]!, size: 10);
    }

    // Path Navigation (Green Line)
    if (showPath) {
      final pathPaint = Paint()
        ..color = const Color(0xFF27AE60)
        ..strokeWidth = 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final path = Path();
      path.moveTo(250, 750); // Start Point
      path.lineTo(250, 450); // Cross Plaza
      path.lineTo(120, 450); // Enteter Block A
      
      if (floor == 3) {
        path.lineTo(120, 250); // Move to Floor 3 Lab
      }

      // Path Shadow
      canvas.drawPath(path, Paint()..color = Colors.green.withOpacity(0.15)..strokeWidth = 10..style = PaintingStyle.stroke);
      canvas.drawPath(path, pathPaint);
      
      // Destination Marker
      final destPaint = Paint()..color = const Color(0xFF27AE60);
      canvas.drawCircle(floor == 3 ? const Offset(120, 250) : const Offset(120, 450), 12, destPaint..color = Colors.white);
      canvas.drawCircle(floor == 3 ? const Offset(120, 250) : const Offset(120, 450), 8, destPaint..color = const Color(0xFF27AE60));
    }

    // User Location Pulse
    final pulsePaint = Paint()..color = const Color(0xFF2F80ED).withOpacity(0.3);
    canvas.drawCircle(Offset(userX, userY), 15, pulsePaint);
    canvas.drawCircle(Offset(userX, userY), 8, Paint()..color = const Color(0xFF2F80ED));
    canvas.drawCircle(Offset(userX, userY), 6, Paint()..color = Colors.white);
  }

  void _drawBlock(Canvas canvas, String name, Offset offset, Size size, Color color) {
    final rect = offset & size;
    final paint = Paint()..color = color;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(15)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(15)), Paint()..color = Colors.black12..style = PaintingStyle.stroke..strokeWidth = 1);
    
    _drawLabel(canvas, Offset(offset.dx + size.width/2, offset.dy + size.height/2), name);
  }

  void _drawLabel(Canvas canvas, Offset offset, String text, {Color color = Colors.black54, double size = 12}) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontSize: size, fontWeight: FontWeight.bold)),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CampusMapPainter oldDelegate) => true;
}
