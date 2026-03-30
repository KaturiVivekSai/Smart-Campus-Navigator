import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isStudent = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        child: Column(
          children: [
            const Icon(Icons.lock_rounded, size: 80, color: Color(0xFF2F80ED)),
            const SizedBox(height: 24),
            const Text(
              'Welcome Explorer',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Select your role to continue',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isStudent = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isStudent ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isStudent ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                        ),
                        child: Text(
                          'Student',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isStudent ? const Color(0xFF2F80ED) : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isStudent = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !isStudent ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: !isStudent ? [const BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
                        ),
                        child: Text(
                          'Staff',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: !isStudent ? const Color(0xFF2F80ED) : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              decoration: InputDecoration(
                labelText: 'Campus Email',
                hintText: 'name@campus.edu',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.vpn_key_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Login', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text('Don\'t have an account? Register'),
            ),
          ],
        ),
      ),
    );
  }
}
