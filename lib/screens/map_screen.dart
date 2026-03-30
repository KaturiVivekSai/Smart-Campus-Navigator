import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Mock Map Background
          Container(
            color: Colors.grey[200],
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Map Rendering...', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          
          // Search Bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Material(
              elevation: 4,
              shadowColor: Colors.black26,
              borderRadius: BorderRadius.circular(30),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for buildings, labs...',
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF2F80ED)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),

          // Filters Scroll
          Positioned(
            top: MediaQuery.of(context).padding.top + 80,
            left: 0,
            right: 0,
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildFilterChip('All', isSelected: true),
                _buildFilterChip('Classrooms'),
                _buildFilterChip('Labs'),
                _buildFilterChip('Offices'),
                _buildFilterChip('Library'),
              ],
            ),
          ),
          
          // Emergency Floating Button
          Positioned(
            bottom: 100,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                _showEmergencyDialog(context);
              },
              backgroundColor: Colors.red,
              child: const Icon(Icons.phone_callback_rounded, color: Colors.white),
            ),
          ),
          
          // Back Button
          Positioned(
            bottom: 40,
            left: 20,
            child: FloatingActionButton.small(
              onPressed: () => Navigator.pop(context),
              backgroundColor: Colors.white,
              child: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Chip(
        label: Text(label),
        backgroundColor: isSelected ? const Color(0xFF2F80ED) : Colors.white,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide.none,
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Emergency Security Call'),
        content: const Text('Initiating direct call to campus security and highlighting route to nearest medical point.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Proceed', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
