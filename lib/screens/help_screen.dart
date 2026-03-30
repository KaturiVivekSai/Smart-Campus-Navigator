import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  String _selectedCategory = 'Suggestion';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Column(
            children: [
              Icon(Icons.check_circle_rounded, color: Color(0xFF27AE60), size: 64),
              SizedBox(height: 16),
              Text('Feedback Submitted', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Thank you for your valuable feedback! We will process it and improve our campus experience.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _usernameController.clear();
                    _feedbackController.clear();
                    _selectedCategory = 'Suggestion';
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF2F80ED),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Great, thanks!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        title: const Text('Feedback Center', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF2F80ED)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('How can we help?', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Your feedback helps us make the campus movement smoother for everyone.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              const Text('Select Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['Suggestion', 'Bug Report', 'Map Issue', 'General Help'].map((category) {
                  bool isSelected = _selectedCategory == category;
                  return InkWell(
                    onTap: () => setState(() => _selectedCategory = category),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF2F80ED) : Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSelected ? const Color(0xFF2F80ED) : Colors.grey[200]!),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              const Text('Username', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: _inputDecoration('Enter your name', Icons.person_outline_rounded),
                validator: (value) => (value == null || value.isEmpty) ? 'Name is required' : null,
              ),
              
              const SizedBox(height: 24),
              
              const Text('Your Feedback', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: _inputDecoration('Write your feedback here...', Icons.chat_bubble_outline_rounded),
                validator: (value) => (value == null || value.isEmpty) ? 'Feedback content is required' : null,
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 4,
                  ),
                  child: const Text('Submit Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF2F80ED)),
      filled: true,
      fillColor: Colors.grey[50],
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }
}
