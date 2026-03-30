import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // After 3 seconds, navigate to Login Screen
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: const Icon(
                Icons.map_rounded,
                size: 100,
                color: Color(0xFF2F80ED),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Smart Campus Navigator',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2F80ED),
              ),
            ),
            const Text(
              'Navigate Your Campus Smartly',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2F80ED)),
            ),
            const SizedBox(height: 20),
            const Text(
              'v1.0.4',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
