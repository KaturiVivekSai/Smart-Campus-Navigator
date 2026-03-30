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
  String _destination = '';
  final TextEditingController _searchController = TextEditingController();
  
  double _userX = 0.5;
  double _userY = 0.85;
  late AnimationController _moveController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Campus locations database
  final Map<String, Map<String, dynamic>> _locations = {
    'Principal Room': {'floor': 2, 'x': 0.35, 'y': 0.22, 'icon': Icons.person, 'block': 'Admin Block'},
    'Admin Office': {'floor': 1, 'x': 0.35, 'y': 0.35, 'icon': Icons.business, 'block': 'Admin Block'},
    'Computer Lab 1': {'floor': 1, 'x': 0.72, 'y': 0.35, 'icon': Icons.computer, 'block': 'Block A'},
    'Computer Lab 2': {'floor': 2, 'x': 0.72, 'y': 0.35, 'icon': Icons.computer, 'block': 'Block A'},
    'Computer Lab 3': {'floor': 3, 'x': 0.72, 'y': 0.22, 'icon': Icons.computer, 'block': 'Block A'},
    'Library': {'floor': 1, 'x': 0.5, 'y': 0.55, 'icon': Icons.menu_book, 'block': 'Block B'},
    'Auditorium': {'floor': 1, 'x': 0.5, 'y': 0.7, 'icon': Icons.theater_comedy, 'block': 'Block C'},
    'Cafeteria': {'floor': 1, 'x': 0.25, 'y': 0.7, 'icon': Icons.restaurant, 'block': 'Ground'},
    'Staff Room': {'floor': 2, 'x': 0.35, 'y': 0.45, 'icon': Icons.groups, 'block': 'Admin Block'},
    'Exam Hall': {'floor': 2, 'x': 0.72, 'y': 0.55, 'icon': Icons.edit_document, 'block': 'Block B'},
    'Sports Room': {'floor': 1, 'x': 0.75, 'y': 0.7, 'icon': Icons.sports_basketball, 'block': 'Block C'},
    'Seminar Hall': {'floor': 3, 'x': 0.5, 'y': 0.45, 'icon': Icons.co_present, 'block': 'Block B'},
  };

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(vsync: this, duration: const Duration(seconds: 8));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.6).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    
    _moveController.addListener(() {
      if (!mounted) return;
      final loc = _locations[_destination];
      if (loc == null) return;
      final targetX = (loc['x'] as double);
      final targetY = (loc['y'] as double);
      setState(() {
        _userX = 0.5 + (_moveController.value * (targetX - 0.5));
        _userY = 0.85 + (_moveController.value * (targetY - 0.85));
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _searchController.text = args;
        _searchLocation(args);
      }
      _hasCheckedArgs = true;
    }
  }

  void _searchLocation(String query) {
    for (var entry in _locations.entries) {
      if (entry.key.toLowerCase().contains(query.toLowerCase())) {
        setState(() {
          _destination = entry.key;
          currentFloor = entry.value['floor'] as int;
          showPath = true;
        });
        return;
      }
    }
  }

  void _startNavigation() {
    setState(() {
      isNavigating = true;
      _userX = 0.5;
      _userY = 0.85;
    });
    _moveController.forward(from: 0);
  }

  void _stopNavigation() {
    _moveController.stop();
    setState(() {
      isNavigating = false;
      showPath = false;
      _destination = '';
      _userX = 0.5;
      _userY = 0.85;
      _searchController.clear();
    });
  }

  @override
  void dispose() {
    _moveController.dispose();
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Stack(
        children: [
          // Campus Map
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return CustomPaint(
                  painter: BuildingMapPainter(
                    floor: currentFloor,
                    showPath: showPath,
                    isNavigating: isNavigating,
                    userX: _userX,
                    userY: _userY,
                    destination: _destination,
                    locations: _locations,
                    pulseScale: _pulseAnimation.value,
                  ),
                );
              },
            ),
          ),

          // Top search/nav bar
          _buildHeader(context),

          // Floor Switcher
          _buildFloorSwitcher(),

          // Destination Card
          if (showPath && !isNavigating) _buildDestinationCard(),

          // Voice button during navigation
          if (isNavigating)
            Positioned(
              right: 16,
              bottom: 90,
              child: Column(
                children: [
                  _hoverButton(
                    icon: Icons.volume_up_rounded,
                    color: const Color(0xFF27AE60),
                    onTap: () => _showVoiceDialog(),
                  ),
                  const SizedBox(height: 12),
                  _hoverButton(
                    icon: Icons.close_rounded,
                    color: Colors.redAccent,
                    onTap: _stopNavigation,
                  ),
                ],
              ),
            ),

          // Back button
          if (!isNavigating)
            Positioned(
              bottom: 90,
              left: 16,
              child: _hoverButton(
                icon: Icons.arrow_back_rounded,
                color: Colors.white,
                iconColor: Colors.black,
                onTap: () => Navigator.pop(context),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isNavigating ? null : _buildBottomNav(context),
    );
  }

  void _showVoiceDialog() {
    final loc = _locations[_destination];
    String guidance = 'Navigating to $_destination';
    if (loc != null) {
      guidance = 'Head towards ${loc['block']}. $_destination is on Floor ${loc['floor']}. Follow the green path.';
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Icon(Icons.record_voice_over_rounded, color: const Color(0xFF2F80ED)),
          const SizedBox(width: 12),
          const Text('Voice Guide'),
        ]),
        content: Text(guidance, style: const TextStyle(fontSize: 16, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _hoverButton({required IconData icon, required Color color, Color iconColor = Colors.white, required VoidCallback onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: isNavigating
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF2F80ED),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15)],
            ),
            child: Row(
              children: [
                const Icon(Icons.navigation_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Navigating to $_destination', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('Floor $currentFloor • Follow green path', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                if (val.length >= 2) _searchLocation(val);
              },
              decoration: InputDecoration(
                hintText: 'Search location...',
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2F80ED)),
                suffixIcon: IconButton(icon: const Icon(Icons.mic_rounded, color: Color(0xFF2F80ED)), onPressed: () {}),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
    );
  }

  Widget _buildFloorSwitcher() {
    return Positioned(
      right: 16,
      top: MediaQuery.of(context).size.height * 0.32,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Column(
          children: [3, 2, 1].map((f) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => setState(() => currentFloor = f),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: currentFloor == f ? const Color(0xFF2F80ED) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text('F$f', style: TextStyle(
                      color: currentFloor == f ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    )),
                  ),
                ),
              ),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildDestinationCard() {
    final loc = _locations[_destination];
    return Positioned(
      bottom: 90,
      left: 16,
      right: 16,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
                  child: Icon(loc?['icon'] ?? Icons.location_on, color: const Color(0xFF2F80ED), size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_destination, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${loc?['block'] ?? ''} • Floor ${loc?['floor'] ?? currentFloor}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: _startNavigation,
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                  label: const Text('Start Navigating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27AE60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
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

// --- Building Map Painter ---
class BuildingMapPainter extends CustomPainter {
  final int floor;
  final bool showPath;
  final bool isNavigating;
  final double userX, userY;
  final String destination;
  final Map<String, Map<String, dynamic>> locations;
  final double pulseScale;

  BuildingMapPainter({
    required this.floor,
    required this.showPath,
    required this.isNavigating,
    required this.userX,
    required this.userY,
    required this.destination,
    required this.locations,
    required this.pulseScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Background
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF0F4FF));

    // Ground/campus area
    final groundPaint = Paint()..color = const Color(0xFFE8F0FE);
    canvas.drawRRect(RRect.fromLTRBR(w * 0.05, h * 0.12, w * 0.95, h * 0.92, const Radius.circular(20)), groundPaint);

    // Draw buildings based on floor
    _drawBuilding(canvas, 'Admin Block', w * 0.08, h * 0.15, w * 0.38, h * 0.28, const Color(0xFFBBDEFB), w, h);
    _drawBuilding(canvas, 'Block A', w * 0.54, h * 0.15, w * 0.38, h * 0.28, const Color(0xFFC8E6C9), w, h);
    _drawBuilding(canvas, 'Block B', w * 0.2, h * 0.48, w * 0.6, h * 0.15, const Color(0xFFFFE0B2), w, h);
    _drawBuilding(canvas, 'Block C', w * 0.08, h * 0.68, w * 0.38, h * 0.18, const Color(0xFFF8BBD0), w, h);
    _drawBuilding(canvas, 'Ground', w * 0.54, h * 0.68, w * 0.38, h * 0.18, const Color(0xFFE1BEE7), w, h);

    // Draw corridors
    final corridorPaint = Paint()..color = const Color(0xFFE0E0E0)..strokeWidth = 3..style = PaintingStyle.stroke;
    // Vertical corridor
    canvas.drawLine(Offset(w * 0.5, h * 0.28), Offset(w * 0.5, h * 0.68), corridorPaint);
    // Horizontal corridors
    canvas.drawLine(Offset(w * 0.08, h * 0.43), Offset(w * 0.92, h * 0.43), corridorPaint);

    // Draw rooms on current floor
    _drawFloorRooms(canvas, w, h);

    // Draw important place labels
    _drawImportantPlaces(canvas, w, h);

    // Draw navigation path
    if (showPath && destination.isNotEmpty) {
      final loc = locations[destination];
      if (loc != null && loc['floor'] == floor) {
        _drawNavigationPath(canvas, w, h, loc['x'] as double, loc['y'] as double);
      }
    }

    // Draw user location
    _drawUserMarker(canvas, w * userX, h * userY, w);

    // Floor label
    final floorTP = TextPainter(
      text: TextSpan(text: 'Floor $floor', style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 16, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    floorTP.paint(canvas, Offset(w * 0.05 + 8, h * 0.12 + 8));
  }

  void _drawBuilding(Canvas canvas, String name, double x, double y, double bw, double bh, Color color, double w, double h) {
    final rect = Rect.fromLTWH(x, y, bw, bh);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(12));

    // Building shadow
    canvas.drawRRect(rrect.shift(const Offset(2, 3)), Paint()..color = Colors.black.withOpacity(0.06));

    // Building body
    canvas.drawRRect(rrect, Paint()..color = color);

    // Building outline
    canvas.drawRRect(rrect, Paint()..color = Colors.black.withOpacity(0.12)..style = PaintingStyle.stroke..strokeWidth = 1.5);

    // Roof line
    canvas.drawLine(Offset(x + 4, y + 4), Offset(x + bw - 4, y + 4), Paint()..color = color.withOpacity(0.8)..strokeWidth = 3..strokeCap = StrokeCap.round);

    // Building name
    final tp = TextPainter(
      text: TextSpan(text: name, style: TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(x + (bw - tp.width) / 2, y + bh - tp.height - 6));

    // Windows
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 3; col++) {
        final wx = x + 10 + col * (bw - 30) / 3;
        final wy = y + 14 + row * 18;
        canvas.drawRRect(
          RRect.fromLTRBR(wx, wy, wx + 12, wy + 10, const Radius.circular(2)),
          Paint()..color = Colors.white.withOpacity(0.7),
        );
      }
    }
  }

  void _drawFloorRooms(Canvas canvas, double w, double h) {
    for (var entry in locations.entries) {
      if (entry.value['floor'] == floor) {
        final rx = w * (entry.value['x'] as double);
        final ry = h * (entry.value['y'] as double);

        // Room dot
        canvas.drawCircle(Offset(rx, ry), 8, Paint()..color = const Color(0xFF2F80ED).withOpacity(0.2));
        canvas.drawCircle(Offset(rx, ry), 5, Paint()..color = const Color(0xFF2F80ED));

        // Room label
        final tp = TextPainter(
          text: TextSpan(text: entry.key, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 8, fontWeight: FontWeight.bold)),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(rx - tp.width / 2, ry + 10));
      }
    }
  }

  void _drawImportantPlaces(Canvas canvas, double w, double h) {
    final important = ['Principal Room', 'Admin Office', 'Library', 'Auditorium'];
    for (var name in important) {
      final loc = locations[name];
      if (loc != null && loc['floor'] == floor) {
        final ix = w * (loc['x'] as double);
        final iy = h * (loc['y'] as double);

        // Star highlight
        canvas.drawCircle(Offset(ix, iy), 14, Paint()..color = Colors.amber.withOpacity(0.3));
        canvas.drawCircle(Offset(ix, iy), 6, Paint()..color = Colors.amber);
        canvas.drawCircle(Offset(ix, iy), 3, Paint()..color = Colors.white);
      }
    }
  }

  void _drawNavigationPath(Canvas canvas, double w, double h, double destX, double destY) {
    final pathPaint = Paint()
      ..color = const Color(0xFF27AE60)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final shadowPaint = Paint()
      ..color = const Color(0xFF27AE60).withOpacity(0.15)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Start from entrance
    path.moveTo(w * 0.5, h * 0.85);
    // Go up corridor
    path.lineTo(w * 0.5, h * 0.43);
    // Go to destination
    if (destX < 0.5) {
      path.lineTo(w * destX, h * 0.43);
      path.lineTo(w * destX, h * destY);
    } else if (destX > 0.5) {
      path.lineTo(w * destX, h * 0.43);
      path.lineTo(w * destX, h * destY);
    } else {
      path.lineTo(w * destX, h * destY);
    }

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, pathPaint);

    // Destination marker
    canvas.drawCircle(Offset(w * destX, h * destY), 14, Paint()..color = const Color(0xFF27AE60).withOpacity(0.3));
    canvas.drawCircle(Offset(w * destX, h * destY), 8, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * destX, h * destY), 6, Paint()..color = const Color(0xFF27AE60));
  }

  void _drawUserMarker(Canvas canvas, double x, double y, double w) {
    // Pulse ring
    canvas.drawCircle(Offset(x, y), 12 * pulseScale, Paint()..color = const Color(0xFF2F80ED).withOpacity(0.15));
    // Outer circle
    canvas.drawCircle(Offset(x, y), 10, Paint()..color = Colors.white);
    // Inner circle
    canvas.drawCircle(Offset(x, y), 7, Paint()..color = const Color(0xFF2F80ED));
    // Direction dot
    canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant BuildingMapPainter oldDelegate) => true;
}
