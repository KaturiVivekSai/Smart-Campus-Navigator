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
  double _userX = 0.5, _userY = 0.85;
  late AnimationController _moveController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

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
    _moveController = AnimationController(vsync: this, duration: const Duration(seconds: 6));
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.6).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _moveController.addListener(_onMoveUpdate);
    _moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        // Path demo complete - return user to start
        _moveController.reverse();
      } else if (status == AnimationStatus.dismissed && isNavigating && mounted) {
        setState(() {}); // User back at start, waiting for real movement
      }
    });
  }

  void _onMoveUpdate() {
    if (!mounted || _destination.isEmpty) return;
    final loc = _locations[_destination];
    if (loc == null) return;
    final tx = loc['x'] as double, ty = loc['y'] as double;
    setState(() {
      _userX = 0.5 + (_moveController.value * (tx - 0.5));
      _userY = 0.85 + (_moveController.value * (ty - 0.85));
    });
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
    setState(() { isNavigating = true; _userX = 0.5; _userY = 0.85; });
    _moveController.forward(from: 0);
  }

  // Close button returns to "ready to navigate" state, NOT back
  void _stopNavigation() {
    _moveController.stop();
    _moveController.value = 0;
    setState(() { isNavigating = false; _userX = 0.5; _userY = 0.85; });
    // Keep showPath and destination so user can re-navigate
  }

  void _clearDestination() {
    _moveController.stop();
    _moveController.value = 0;
    setState(() { isNavigating = false; showPath = false; _destination = ''; _userX = 0.5; _userY = 0.85; _searchController.clear(); });
  }

  // Tap on map to place destination
  void _onMapTap(TapUpDetails details, BoxConstraints constraints) {
    if (isNavigating) return;
    final w = constraints.maxWidth, h = constraints.maxHeight;
    final tapX = details.localPosition.dx / w;
    final tapY = details.localPosition.dy / h;
    // Find nearest location on current floor
    String nearest = '';
    double minDist = double.infinity;
    for (var e in _locations.entries) {
      if (e.value['floor'] != currentFloor) continue;
      final dx = tapX - (e.value['x'] as double);
      final dy = tapY - (e.value['y'] as double);
      final d = dx * dx + dy * dy;
      if (d < minDist) { minDist = d; nearest = e.key; }
    }
    if (nearest.isNotEmpty && minDist < 0.05) {
      setState(() { _destination = nearest; showPath = true; _searchController.text = nearest; });
    }
  }

  @override
  void dispose() { _moveController.dispose(); _pulseController.dispose(); _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: Stack(children: [
        Positioned.fill(
          child: LayoutBuilder(builder: (context, constraints) {
            return GestureDetector(
              onTapUp: (d) => _onMapTap(d, constraints),
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) => CustomPaint(
                  painter: BuildingMapPainter(floor: currentFloor, showPath: showPath, isNavigating: isNavigating,
                    userX: _userX, userY: _userY, destination: _destination, locations: _locations, pulseScale: _pulseAnim.value),
                ),
              ),
            );
          }),
        ),
        _buildHeader(context),
        _buildFloorSwitcher(),
        if (showPath && !isNavigating) _buildDestinationCard(),
        if (isNavigating) Positioned(right: 16, bottom: 90, child: Column(children: [
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
    String g = loc != null ? 'Head towards ${loc['block']}. $_destination is on Floor ${loc['floor']}. Follow the green path.' : 'Navigating...';
    showDialog(context: context, builder: (c) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(children: [const Icon(Icons.record_voice_over_rounded, color: Color(0xFF2F80ED)), const SizedBox(width: 12), const Text('Voice Guide')]),
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
                Text('Floor $currentFloor • Follow green path', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ])),
            ]))
        : Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10)]),
            child: TextField(controller: _searchController, onChanged: (v) { if (v.length >= 2) _searchLocation(v); },
              decoration: InputDecoration(hintText: 'Search location...', prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2F80ED)),
                suffixIcon: IconButton(icon: const Icon(Icons.mic_rounded, color: Color(0xFF2F80ED)), onPressed: () {}),
                border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(vertical: 15)))));
  }

  Widget _buildFloorSwitcher() => Positioned(right: 16, top: MediaQuery.of(context).size.height * 0.32,
    child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 8)]),
      child: Column(children: [3, 2, 1].map((f) => Padding(padding: const EdgeInsets.symmetric(vertical: 4),
        child: GestureDetector(onTap: () => setState(() => currentFloor = f),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), width: 42, height: 42,
            decoration: BoxDecoration(color: currentFloor == f ? const Color(0xFF2F80ED) : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Center(child: Text('F$f', style: TextStyle(color: currentFloor == f ? Colors.white : Colors.black54, fontWeight: FontWeight.bold, fontSize: 13))))))).toList())));

  Widget _buildDestinationCard() {
    final loc = _locations[_destination];
    return Positioned(bottom: 90, left: 16, right: 16,
      child: Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 20)]),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(loc?['icon'] ?? Icons.location_on, color: const Color(0xFF2F80ED), size: 28)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_destination, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('${loc?['block'] ?? ''} • Floor ${loc?['floor'] ?? currentFloor}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
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
  final double userX, userY; final String destination;
  final Map<String, Map<String, dynamic>> locations; final double pulseScale;
  BuildingMapPainter({required this.floor, required this.showPath, required this.isNavigating, required this.userX, required this.userY, required this.destination, required this.locations, required this.pulseScale});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFFF0F4FF));
    canvas.drawRRect(RRect.fromLTRBR(w * 0.05, h * 0.12, w * 0.95, h * 0.92, const Radius.circular(20)), Paint()..color = const Color(0xFFE8F0FE));
    _bld(canvas, 'Admin Block', w * 0.08, h * 0.15, w * 0.38, h * 0.28, const Color(0xFFBBDEFB));
    _bld(canvas, 'Block A', w * 0.54, h * 0.15, w * 0.38, h * 0.28, const Color(0xFFC8E6C9));
    _bld(canvas, 'Block B', w * 0.2, h * 0.48, w * 0.6, h * 0.15, const Color(0xFFFFE0B2));
    _bld(canvas, 'Block C', w * 0.08, h * 0.68, w * 0.38, h * 0.18, const Color(0xFFF8BBD0));
    _bld(canvas, 'Ground', w * 0.54, h * 0.68, w * 0.38, h * 0.18, const Color(0xFFE1BEE7));
    final cp = Paint()..color = const Color(0xFFE0E0E0)..strokeWidth = 3..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.5, h * 0.28), Offset(w * 0.5, h * 0.68), cp);
    canvas.drawLine(Offset(w * 0.08, h * 0.43), Offset(w * 0.92, h * 0.43), cp);
    for (var e in locations.entries) {
      if (e.value['floor'] != floor) continue;
      final rx = w * (e.value['x'] as double), ry = h * (e.value['y'] as double);
      final imp = ['Principal Room', 'Admin Office', 'Library', 'Auditorium'].contains(e.key);
      if (imp) { canvas.drawCircle(Offset(rx, ry), 14, Paint()..color = Colors.amber.withOpacity(0.3)); canvas.drawCircle(Offset(rx, ry), 6, Paint()..color = Colors.amber); canvas.drawCircle(Offset(rx, ry), 3, Paint()..color = Colors.white); }
      else { canvas.drawCircle(Offset(rx, ry), 8, Paint()..color = const Color(0xFF2F80ED).withOpacity(0.2)); canvas.drawCircle(Offset(rx, ry), 5, Paint()..color = const Color(0xFF2F80ED)); }
      final tp = TextPainter(text: TextSpan(text: e.key, style: const TextStyle(color: Color(0xFF1565C0), fontSize: 8, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(rx - tp.width / 2, ry + 10));
    }
    if (showPath && destination.isNotEmpty) {
      final loc = locations[destination];
      if (loc != null && loc['floor'] == floor) {
        final dx = loc['x'] as double, dy = loc['y'] as double;
        final path = Path()..moveTo(w * 0.5, h * 0.85)..lineTo(w * 0.5, h * 0.43)..lineTo(w * dx, h * 0.43)..lineTo(w * dx, h * dy);
        canvas.drawPath(path, Paint()..color = const Color(0xFF27AE60).withOpacity(0.15)..strokeWidth = 12..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
        canvas.drawPath(path, Paint()..color = const Color(0xFF27AE60)..strokeWidth = 4..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
        canvas.drawCircle(Offset(w * dx, h * dy), 14, Paint()..color = const Color(0xFF27AE60).withOpacity(0.3));
        canvas.drawCircle(Offset(w * dx, h * dy), 8, Paint()..color = Colors.white);
        canvas.drawCircle(Offset(w * dx, h * dy), 6, Paint()..color = const Color(0xFF27AE60));
      }
    }
    canvas.drawCircle(Offset(w * userX, h * userY), 12 * pulseScale, Paint()..color = const Color(0xFF2F80ED).withOpacity(0.15));
    canvas.drawCircle(Offset(w * userX, h * userY), 10, Paint()..color = Colors.white);
    canvas.drawCircle(Offset(w * userX, h * userY), 7, Paint()..color = const Color(0xFF2F80ED));
    canvas.drawCircle(Offset(w * userX, h * userY), 3, Paint()..color = Colors.white);
    final ft = TextPainter(text: TextSpan(text: 'Floor $floor', style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 16, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    ft.paint(canvas, Offset(w * 0.05 + 8, h * 0.12 + 8));
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
