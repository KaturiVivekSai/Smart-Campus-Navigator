import 'package:flutter/material.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Assistance'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, size: 100, color: Colors.redAccent),
            const SizedBox(height: 16),
            const Text(
              'Immediate Help',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Press the button below for instant security alert',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () {
                _showSOSDialog(context);
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      spreadRadius: 10,
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'SOS',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEmergencyAction(Icons.local_police, 'Security'),
                _buildEmergencyAction(Icons.medical_services, 'Medical'),
                _buildEmergencyAction(Icons.local_fire_department, 'Fire'),
              ],
            ),
            const SizedBox(height: 32),
            _buildSafetyTips(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyAction(IconData icon, String label) {
    return Column(
      children: [
        IconButton.filled(
          icon: Icon(icon),
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.redAccent,
            side: const BorderSide(color: Colors.redAccent),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSafetyTips() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Safety Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('1. Stay calm and alert.'),
          Text('2. Reach the nearest safe point.'),
          Text('3. Keep your phone battery charged.'),
        ],
      ),
    );
  }

  void _showSOSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('SOS Alert Sent'),
        content: const Text('Authorities have been notified of your location. Please stay where you are.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }
}
