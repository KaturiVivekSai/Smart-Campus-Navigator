import 'package:flutter/material.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  int currentFloor = 0; // 0 = Ground
  bool isNavigating = false;
  bool showPath = false;
  bool _hasCheckedArgs = false;
  String _destination = '';
  final TextEditingController _searchController = TextEditingController();
  
  double _userX = 0.5, _userY = 0.85; // Starting position
  double _userRotation = 0.0; // Angle facing
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final Map<String, Map<String, dynamic>> _locations = {
    'Principal Room': {'floor': 0, 'x': 0.35, 'y': 0.22, 'icon': Icons.person, 'block': 'Admin Block'},
    'Admin Office': {'floor': 1, 'x': 0.35, 'y': 0.35, 'icon': Icons.business, 'block': 'Admin Block'},
    'Staff Room': {'floor': 2, 'x': 0.35, 'y': 0.45, 'icon': Icons.groups, 'block': 'Admin Block'},
    'Computer Lab 1': {'floor': 1, 'x': 0.72, 'y': 0.35, 'icon': Icons.computer, 'block': 'Block A'},
    'Computer Lab 2': {'floor': 2, 'x': 0.72, 'y': 0.35, 'icon': Icons.computer, 'block': 'Block A'},
    'Computer Lab 3': {'floor': 3, 'x': 0.72, 'y': 0.22, 'icon': Icons.computer, 'block': 'Block A'},
    'Library': {'floor': 1, 'x': 0.5, 'y': 0.55, 'icon': Icons.menu_book, 'block': 'Block B'},
    'Physics Lab': {'floor': 1, 'x': 0.72, 'y': 0.45, 'icon': Icons.science, 'block': 'Block A'},
    'Chemistry Lab': {'floor': 2, 'x': 0.5, 'y': 0.55, 'icon': Icons.science, 'block': 'Block B'},
    'Drawing Lab': {'floor': 2, 'x': 0.25, 'y': 0.7, 'icon': Icons.draw, 'block': 'Block C'},
    'Auditorium': {'floor': 1, 'x': 0.5, 'y': 0.7, 'icon': Icons.theater_comedy, 'block': 'Block C'},
    'Cafeteria': {'floor': 0, 'x': 0.25, 'y': 0.7, 'icon': Icons.restaurant, 'block': 'Ground'},
    'Exam Hall': {'floor': 2, 'x': 0.72, 'y': 0.55, 'icon': Icons.edit_document, 'block': 'Block B'},
    'Sports Room': {'floor': 1, 'x': 0.75, 'y': 0.7, 'icon': Icons.sports_basketball, 'block': 'Block C'},
    'Seminar Hall': {'floor': 3, 'x': 0.5, 'y': 0.45, 'icon': Icons.co_present, 'block': 'Block B'},
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.6).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasCheckedArgs) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) { _searchController.text = args; _searchLocation(args); }
      _hasCheckedArgs = true;
    }
  }

  void _searchLocation(String q) {
    for (var e in _locations.entries) {
      if (e.key.toLowerCase().contains(q.toLowerCase())) {
        setState(() { _destination = e.key; currentFloor = e.value['floor'] as int; showPath = true; });
        return;
      }
    }
  }

  void _startNavigation() {
    setState(() { 
      isNavigating = true; 
      _userX = 0.5; _userY = 0.85; _userRotation = 0.0;
      currentFloor = 0; // Start at Ground floor
    });
  }

  // Simulates real-world movement step by step to mimic GPS
  void _stepForward() {
    final loc = _locations[_destination];
    if (loc == null) return;
    
    // Check if we need to change floors first
    final destFloor = loc['floor'] as int;
    if (currentFloor != destFloor && _userY <= 0.45) {
      // Reached stairs point (approx 0.5, 0.43)
      setState(() => currentFloor = destFloor);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Switched to Floor $destFloor 🪜'), duration: const Duration(seconds: 1)));
      return;
    }
    
    // Waypoints calculation
    List<Offset> waypoints = [const Offset(0.5, 0.85), const Offset(0.5, 0.43)];
    final destX = loc['x'] as double;
    final destY = loc['y'] as double;
    if (destX != 0.5) waypoints.add(Offset(destX, 0.43));
    waypoints.add(Offset(destX, destY));

    // Find current segment
    for (int i = 0; i < waypoints.length - 1; i++) {
      Offset p1 = waypoints[i];
      Offset p2 = waypoints[i+1];
      
      // Check if user is on this segment
      if (_userX == p1.dx && _userY == p1.dy) {
        // Move towards p2
        _moveUserTowardsPoint(p2);
        return;
      }
      
      // If moving along segment
      final dist1 = sqrt(pow(_userX - p1.dx, 2) + pow(_userY - p1.dy, 2));
      final dist2 = sqrt(pow(_userX - p2.dx, 2) + pow(_userY - p2.dy, 2));
      final segLen = sqrt(pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2));
      
      if ((dist1 + dist2) - segLen < 0.01) {
        _moveUserTowardsPoint(p2);
        return;
      }
    }
  }

  void _moveUserTowardsPoint(Offset target) {
    const stepSize = 0.08;
    double dx = target.dx - _userX;
    double dy = target.dy - _userY;
    double dist = sqrt(dx*dx + dy*dy);
    
    if (dist <= stepSize) {
      setState(() { _userX = target.dx; _userY = target.dy; });
      // If reached final destination
      if (_userX == _locations[_destination]!['x'] && _userY == _locations[_destination]!['y']) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You have arrived at your destination! 🎉'), backgroundColor: Color(0xFF27AE60)));
      }
    } else {
      setState(() {
        _userX += (dx / dist) * stepSize;
        _userY += (dy / dist) * stepSize;
        _userRotation = atan2(dy, dx) + pi/2; // Orient triangle
      });
    }
  }

  void _stopNavigation() {
    setState(() { isNavigating = false; _userX = 0.5; _userY = 0.85; _userRotation = 0; });
  }

  void _clearDestination() {
    setState(() { isNavigating = false; showPath = false; _destination = ''; _userX = 0.5; _userY = 0.85; _searchController.clear(); });
  }

  @override
  void dispose() { _pulseController.dispose(); _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Stack(children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => CustomPaint(
              painter: BuildingMapPainter(floor: currentFloor, showPath: showPath, isNavigating: isNavigating,
                userX: _userX, userY: _userY, userRotation: _userRotation, destination: _destination, locations: _locations, pulseScale: _pulseAnim.value),
            ),
          ),
        ),
        _buildHeader(context),
        _buildFloorSwitcher(),
        if (showPath && !isNavigating) _buildDestinationCard(),
        if (isNavigating) Positioned(right: 16, bottom: 90, child: Column(children: [
          _hoverBtn(Icons.directions_walk_rounded, const Color(0xFF2F80ED), _stepForward),
          const SizedBox(height: 12),
          _hoverBtn(Icons.volume_up_rounded, const Color(0xFF27AE60), _showVoice),
          const SizedBox(height: 12),
          _hoverBtn(Icons.stop_rounded, Colors.redAccent, _stopNavigation),
        ])),
        if (!isNavigating && showPath) Positioned(left: 16, bottom: 90, child: _hoverBtn(Icons.clear_rounded, Colors.grey, _clearDestination)),
      ]),
      bottomNavigationBar: isNavigating ? null : _buildNav(context),
    );
  }

  void _showVoice() {
    final loc = _locations[_destination];
    String destFloor = loc!['floor'].toString();
    if (destFloor == '0') destFloor = 'Ground';
    String currFloor = currentFloor.toString();
    if (currentFloor == 0) currFloor = 'Ground';
    
    String g = 'Head towards ${loc['block']}. $_destination is on Floor $destFloor. You are on Floor $currFloor.';
    if (loc['floor'] != currentFloor) g += ' Follow the path to the stairs.';
    
    showDialog(context: context, builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(children: [Icon(Icons.record_voice_over_rounded, color: Color(0xFF2F80ED)), SizedBox(width: 12), Text('Voice Guide')]),
      content: Text(g, style: const TextStyle(fontSize: 16, height: 1.5)),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('Got it', style: TextStyle(fontWeight: FontWeight.bold)))],
    ));
  }

  Widget _hoverBtn(IconData ic, Color c, VoidCallback onTap) => MouseRegion(cursor: SystemMouseCursors.click, child: GestureDetector(onTap: onTap,
    child: Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: c, shape: BoxShape.circle,
      boxShadow: [BoxShadow(color: c.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Icon(ic, color: Colors.white, size: 22))));

  Widget _buildHeader(BuildContext context) {
    return Positioned(top: MediaQuery.of(context).padding.top + 12, left: 16, right: 16,
      child: isNavigating
        ? Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(color: const Color(0xFF2F80ED), borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 15)]),
            child: Row(children: [
              const Icon(Icons.navigation_rounded, color: Colors.white), const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Navigating to $_destination', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Floor ${currentFloor == 0 ? "Ground" : currentFloor} • Press Walk Icon to advance', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]))
        : Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)]),
            child: TextField(controller: _searchController, onChanged: (v) { if (v.length >= 2) _searchLocation(v); },
              decoration: InputDecoration(hintText: 'Search location...', prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2F80ED)),
                border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15)))));
  }

  Widget _buildFloorSwitcher() => Positioned(right: 16, top: MediaQuery.of(context).size.height * 0.32,
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Column(children: [3, 2, 1, 0].map((f) => Padding(padding: const EdgeInsets.symmetric(vertical: 4),
        child: GestureDetector(onTap: () => setState(() => currentFloor = f),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 42, height: 42,
            decoration: BoxDecoration(color: currentFloor == f ? const Color(0xFF2F80ED) : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text(f == 0 ? 'G' : 'F$f', style: TextStyle(color: currentFloor == f ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 13))))))).toList())));

  Widget _buildDestinationCard() {
    final loc = _locations[_destination];
    String floorStr = loc?['floor'].toString() ?? currentFloor.toString();
    if (floorStr == '0') floorStr = 'Ground';
    
    return Positioned(bottom: 90, left: 16, right: 16,
      child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 20)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(loc?['icon'] ?? Icons.location_on, color: const Color(0xFF2F80ED), size: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_destination, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${loc?['block'] ?? ''} • Floor $floorStr', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ])),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: _startNavigation,
            icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            label: const Text('Start Navigating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF27AE60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 4))),
        ])));
  }

  Widget _buildNav(BuildContext context) => BottomNavigationBar(currentIndex: 1, type: BottomNavigationBarType.fixed, selectedItemColor: const Color(0xFF2F80ED),
    onTap: (i) { if (i == 0) Navigator.pushReplacementNamed(context, '/home'); else if (i == 2) Navigator.pushNamed(context, '/search'); else if (i == 3) Navigator.pushNamed(context, '/help'); else if (i == 4) Navigator.pushNamed(context, '/profile'); },
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.map_rounded), label: 'Map'),
      BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.feedback_outlined), label: 'Help'),
      BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
    ]);
}

class BuildingMapPainter extends CustomPainter {
  final int floor; final bool showPath, isNavigating;
  final double userX, userY, userRotation; final String destination;
  final Map<String, Map<String, dynamic>> locations; final double pulseScale;
  BuildingMapPainter({required this.floor, required this.showPath, required this.isNavigating, required this.userX, required this.userY, required this.userRotation, required this.destination, required this.locations, required this.pulseScale});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF0F4FF));
    canvas.drawRRect(RRect.fromLTRBR(w * 0.05, h * 0.12, w * 0.95, h * 0.92, const Radius.circular(20)), Paint()..color = const Color(0xFFE8F0FE));
    
    // Buildings
    _bld(canvas, 'Admin Block', w * 0.08, h * 0.15, w * 0.38, h * 0.28, const Color(0xFFBBDEFB));
    _bld(canvas, 'Block A', w * 0.54, h * 0.15, w * 0.38, h * 0.28, const Color(0xFFC8E6C9));
    _bld(canvas, 'Block B', w * 0.2, h * 0.48, w * 0.6, h * 0.15, const Color(0xFFFFE0B2));
    _bld(canvas, 'Block C', w * 0.08, h * 0.68, w * 0.38, h * 0.18, const Color(0xFFF8BBD0));
    _bld(canvas, 'Ground', w * 0.54, h * 0.68, w * 0.38, h * 0.18, const Color(0xFFE1BEE7));
    
    // Corridors
    final cp = Paint()..color = const Color(0xFFE0E0E0)..strokeWidth = 3..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.5, h * 0.28), Offset(w * 0.5, h * 0.85), cp); // Vertical main
    canvas.drawLine(Offset(w * 0.08, h * 0.43), Offset(w * 0.92, h * 0.43), cp); // Horizontal cross
    
    // Draw Stairs icon at intersection
    _drawStairs(canvas, w * 0.5, h * 0.43);

    // Locations
    for (var e in locations.entries) {
      if (e.value['floor'] != floor) continue;
      final rx = w * (e.value['x'] as double), ry = h * (e.value['y'] as double);
      if (e.key == 'Principal Room') { 
        canvas.drawCircle(Offset(rx, ry), 14, Paint()..color = Colors.amber.withOpacity(0.3)); 
        canvas.drawCircle(Offset(rx, ry), 6, Paint()..color = Colors.amber); 
        canvas.drawCircle(Offset(rx, ry), 3, Paint()..color = Colors.white); 
      } else { 
        canvas.drawCircle(Offset(rx, ry), 8, Paint()..color = const Color(0xFF2F80ED).withOpacity(0.2)); 
        canvas.drawCircle(Offset(rx, ry), 5, Paint()..color = const Color(0xFF2F80ED)); 
      }
      final tp = TextPainter(text: TextSpan(text: e.key, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 8, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(rx - tp.width / 2, ry + 10));
    }

    // Path
    if (showPath && destination.isNotEmpty) {
      final loc = locations[destination];
      if (loc != null) {
        final dx = loc['x'] as double, dy = loc['y'] as double, dFloor = loc['floor'] as int;
        
        // Show path if user is on the floor where path starts (0) or path ends (dFloor)
        if (floor == 0 || floor == dFloor) {
          final path = Path();
          // Ground floor path segment to stairs
          if (floor == 0 && dFloor != 0) {
            path.moveTo(w * 0.5, h * 0.85);
            path.lineTo(w * 0.5, h * 0.43);
          } 
          // Final floor path segment from stairs to room
          else if (floor == dFloor && dFloor != 0) {
            path.moveTo(w * 0.5, h * 0.43); // stairs
            path.lineTo(w * dx, h * 0.43);
            path.lineTo(w * dx, h * dy);
          }
          // Same floor direct path
          else if (floor == 0 && dFloor == 0) {
            path.moveTo(w * 0.5, h * 0.85);
            path.lineTo(w * 0.5, h * 0.43);
            path.lineTo(w * dx, h * 0.43);
            path.lineTo(w * dx, h * dy);
          }

          canvas.drawPath(path, Paint()..color = const Color(0xFF27AE60).withOpacity(0.15)..strokeWidth = 12..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
          canvas.drawPath(path, Paint()..color = const Color(0xFF27AE60)..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
          
          if (floor == dFloor) {
            canvas.drawCircle(Offset(w * dx, h * dy), 14, Paint()..color = const Color(0xFF27AE60).withOpacity(0.3));
            canvas.drawCircle(Offset(w * dx, h * dy), 8, Paint()..color = Colors.white);
            canvas.drawCircle(Offset(w * dx, h * dy), 6, Paint()..color = const Color(0xFF27AE60));
          }
        }
      }
    }
    
    // Draw User Location as a Triangle
    if (!isNavigating || true) {
      canvas.drawCircle(Offset(w * userX, h * userY), 16 * pulseScale, Paint()..color = const Color(0xFF2F80ED).withOpacity(0.2));
      canvas.save();
      canvas.translate(w * userX, h * userY);
      canvas.rotate(userRotation);
      final pointerPath = Path()
        ..moveTo(0, -9)
        ..lineTo(7, 7)
        ..lineTo(0, 3)
        ..lineTo(-7, 7)
        ..close();
      canvas.drawPath(pointerPath, Paint()..color = Colors.white);
      canvas.drawPath(pointerPath, Paint()..color = const Color(0xFF2F80ED)..style = PaintingStyle.stroke..strokeWidth = 2);
      canvas.restore();
    }
    
    final ft = TextPainter(text: TextSpan(text: floor == 0 ? 'Ground' : 'Floor $floor', style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 16, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    ft.paint(canvas, Offset(w * 0.05 + 8, h * 0.12 + 8));
  }

  void _drawStairs(Canvas c, double cx, double cy) {
    c.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: 16, height: 16), Paint()..color = Colors.orange.withOpacity(0.2));
    c.drawRect(Rect.fromCenter(center: Offset(cx, cy), width: 16, height: 16), Paint()..color = Colors.orange..style = PaintingStyle.stroke..strokeWidth = 1.5);
    final pt = Paint()..color = Colors.orange..strokeWidth = 1;
    for (int i=-2; i<=2; i++) c.drawLine(Offset(cx - 6, cy + i*3), Offset(cx + 6, cy + i*3), pt);
  }

  void _bld(Canvas c, String n, double x, double y, double bw, double bh, Color col) {
    final r = RRect.fromRectAndRadius(Rect.fromLTWH(x, y, bw, bh), const Radius.circular(12));
    c.drawRRect(r.shift(const Offset(2, 3)), Paint()..color = Colors.black.withOpacity(0.06));
    c.drawRRect(r, Paint()..color = col);
    c.drawRRect(r, Paint()..color = Colors.black.withOpacity(0.12)..style = PaintingStyle.stroke..strokeWidth = 1.5);
    for (int row = 0; row < 2; row++) for (int col2 = 0; col2 < 3; col2++) {
      c.drawRRect(RRect.fromLTRBR(x + 10 + col2 * (bw - 30) / 3, y + 14 + row * 18, x + 22 + col2 * (bw - 30) / 3, y + 24 + row * 18, const Radius.circular(2)), Paint()..color = Colors.white.withOpacity(0.7));
    }
    final tp = TextPainter(text: TextSpan(text: n, style: const TextStyle(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    tp.paint(c, Offset(x + (bw - tp.width) / 2, y + bh - tp.height - 6));
  }

  @override
  bool shouldRepaint(covariant BuildingMapPainter o) => true;
}
