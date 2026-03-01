import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/vendor.dart';
import '../widgets/vendor_card.dart';
import 'vendor_detail_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  final _searchController = TextEditingController();
  List<Vendor> _vendors = [];
  bool _isLoading = false;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _loadVendors();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name');
    });
  }

  Future<void> _loadVendors({String? search}) async {
    setState(() => _isLoading = true);
    try {
      final vendors = await _apiService.getVendors(search: search);
      setState(() => _vendors = vendors);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatkaraConnect'),
        backgroundColor: Colors.orange[600],
        elevation: 0,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('My Orders'),
                onTap: () {
                  // Navigate to orders screen
                },
              ),
              PopupMenuItem(
                child: const Text('Settings'),
                onTap: () {
                  // Navigate to settings
                },
              ),
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with greeting
            Container(
              color: Colors.orange[600],
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${_userName ?? 'User'}!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Find the perfect caterer for your event',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  _loadVendors(search: value.isEmpty ? null : value);
                },
                decoration: InputDecoration(
                  hintText: 'Search vendors...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            // Vendors Grid
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  )
                : _vendors.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            const Icon(Icons.search_off, size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text(
                              'No vendors found',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _vendors.length,
                          itemBuilder: (context, index) {
                            return VendorCard(
                              vendor: _vendors[index],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => VendorDetailScreen(
                                      vendorId: _vendors[index].id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
