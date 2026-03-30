import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedRole = 'Student';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Column(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF27AE60), size: 64),
              SizedBox(height: 16),
              Text('Registration Successful'),
            ],
          ),
          content: const Text(
            'Your account has been created successfully. You can now log in to the Smart Campus Navigator.',
            textAlign: TextAlign.center,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to login
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Go to Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }
  }

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
        title: const Text('Create Account', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Center for premium feel
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF2F80ED).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.person_add_rounded, size: 64, color: Color(0xFF2F80ED)),
              ),
              const SizedBox(height: 24),
              const Text('Join the Community', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                'Access advanced campus navigation features',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              const Align(alignment: Alignment.centerLeft, child: Text('I am registering as:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildRoleButton('Student', Icons.school_rounded)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRoleButton('Staff', Icons.badge_rounded)),
                ],
              ),
              
              const SizedBox(height: 40),
              
              _buildModernField(_nameController, 'Full Name', Icons.person_outline_rounded),
              const SizedBox(height: 20),
              _buildModernField(_emailController, 'University Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildModernField(_idController, 'University ID (e.g. ST123)', Icons.badge_outlined),
              const SizedBox(height: 20),
              _buildModernField(_passwordController, 'Create Password', Icons.lock_outline_rounded, obscureText: true),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                  ),
                  child: const Text('Complete Registration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role, IconData icon) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F80ED) : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? const Color(0xFF2F80ED) : Colors.grey[200]!),
          boxShadow: isSelected ? [BoxShadow(color: const Color(0xFF2F80ED).withOpacity(0.2), blurRadius: 8)] : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? Colors.white : Colors.grey[600], size: 20),
            const SizedBox(width: 8),
            Text(role, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildModernField(TextEditingController controller, String label, IconData icon, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF2F80ED)),
        filled: true,
        fillColor: Colors.grey[50],
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.grey[200]!)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2)),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter $label';
        if (label.contains('Password') && value.length < 6) return 'Password must be at least 6 characters';
        return null;
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
