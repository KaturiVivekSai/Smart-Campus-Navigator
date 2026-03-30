import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const SmartCampusNavigator());
}

class SmartCampusNavigator extends StatelessWidget {
  const SmartCampusNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Campus Navigator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: const Color(0xFF2F80ED),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2F80ED),
          primary: const Color(0xFF2F80ED),
          surface: const Color(0xFFFAFAFA),
        ),
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/map': (context) => const MapScreen(),
        '/search': (context) => const SearchScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/emergency': (context) => const EmergencyScreen(),
      },
    );
  }
}
