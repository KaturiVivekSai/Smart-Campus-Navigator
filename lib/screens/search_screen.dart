import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = ['Library', 'Canteen', 'IT Block', 'Hostel A'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search campus...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => _searchController.clear(),
            ),
          ),
          autofocus: true,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Searches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _recentSearches.map((search) {
                return ActionChip(
                  label: Text(search),
                  onPressed: () => _searchController.text = search,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Text(
              'Quick Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  _buildCategoryItem(Icons.apartment, 'Buildings'),
                  _buildCategoryItem(Icons.restaurant, 'Dining'),
                  _buildCategoryItem(Icons.local_hospital, 'Medical'),
                  _buildCategoryItem(Icons.event, 'Events'),
                  _buildCategoryItem(Icons.sports_soccer, 'Sports'),
                  _buildCategoryItem(Icons.library_books, 'Library'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2F80ED).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF2F80ED)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
