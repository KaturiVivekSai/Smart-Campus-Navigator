import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _recentPlaces = [
    {'name': 'Computer Lab 3', 'location': 'Block A, Floor 3', 'icon': Icons.computer_rounded, 'time': '2h ago'},
    {'name': 'Main Admin Office', 'location': 'Block A, Ground Floor', 'icon': Icons.business_rounded, 'time': '5h ago'},
    {'name': 'Central Library', 'location': 'Block C, Floor 1', 'icon': Icons.menu_book_rounded, 'time': 'Yesterday'},
  ];

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
        title: const Text('Search Campus', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Premium Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Buildings, Labs, or People...',
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF2F80ED), size: 24),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.mic_none_rounded, color: Color(0xFF2F80ED), size: 24),
                    onPressed: () {},
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onSubmitted: (val) {
                  if (val.isNotEmpty) Navigator.pushNamed(context, '/map', arguments: val);
                },
              ),
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recently Visited',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  
                  // Recent Places List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _recentPlaces.length,
                    separatorBuilder: (context, index) => const Divider(height: 32, color: Color(0xFFF1F1F1)),
                    itemBuilder: (context, index) {
                      final place = _recentPlaces[index];
                      return InkWell(
                        onTap: () => Navigator.pushNamed(context, '/map', arguments: place['name']),
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2F80ED).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(place['icon'], color: const Color(0xFF2F80ED), size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(place['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text(place['location'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                ],
                              ),
                            ),
                            Text(place['time'], style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  const Text(
                    'Browse Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  
                  // Categories Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.5,
                    children: [
                      _buildCategoryItem(Icons.school_rounded, 'Academics', Colors.blue),
                      _buildCategoryItem(Icons.science_rounded, 'Laboratories', Colors.purple),
                      _buildCategoryItem(Icons.restaurant_rounded, 'Cafeteria', Colors.orange),
                      _buildCategoryItem(Icons.sports_basketball_rounded, 'Sports Complex', Colors.green),
                      _buildCategoryItem(Icons.local_library_rounded, 'E-Library', Colors.indigo),
                      _buildCategoryItem(Icons.meeting_room_rounded, 'Admin Bloc', Colors.teal),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, '/map', arguments: label),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
