import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/search_screen.dart';
import 'screens/emergency_screen.dart';
import 'screens/register_screen.dart';
import 'screens/help_screen.dart';

// --- Simple State Management ---
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _currentUserRole;
  bool _isLoggedIn = false;

  String? get currentUserRole => _currentUserRole;
  bool get isLoggedIn => _isLoggedIn;

  void login(String role) {
    _currentUserRole = role;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _currentUserRole = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}

final authService = AuthService();

void main() {
  runApp(const SmartCampusNavigator());
}

class SmartCampusNavigator extends StatelessWidget {
  const SmartCampusNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
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
              brightness: Brightness.light,
            ),
            fontFamily: 'Poppins',
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF2F80ED),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2F80ED),
              brightness: Brightness.dark,
            ),
            fontFamily: 'Poppins',
          ),
          themeMode: ThemeMode.system,
          initialRoute: '/',
          routes: {
            '/': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => _protectedRoute(const HomeScreen()),
            '/map': (context) => _protectedRoute(const MapScreen()),
            '/search': (context) => _protectedRoute(const SearchScreen()),
            '/profile': (context) => _protectedRoute(const ProfileScreen()),
            '/emergency': (context) => _protectedRoute(const EmergencyScreen()),
            '/help': (context) => _protectedRoute(const HelpScreen()),
          },
        );
      }
    );
  }

  Widget _protectedRoute(Widget child) {
    return authService.isLoggedIn ? child : const LoginScreen();
  }
}
