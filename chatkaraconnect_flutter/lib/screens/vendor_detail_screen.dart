import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../services/api_service.dart';
import '../models/vendor.dart';
import '../models/feedback.dart';
import '../widgets/custom_widgets.dart';
import 'booking_screen.dart';

class VendorDetailScreen extends StatefulWidget {
  final int vendorId;

  const VendorDetailScreen({Key? key, required this.vendorId}) : super(key: key);

  @override
  State<VendorDetailScreen> createState() => _VendorDetailScreenState();
}

class _VendorDetailScreenState extends State<VendorDetailScreen> {
  final _apiService = ApiService();
  Vendor? _vendor;
  List<Feedback> _feedback = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVendorDetail();
  }

  Future<void> _loadVendorDetail() async {
    try {
      final vendor = await _apiService.getVendorDetail(widget.vendorId);
      final feedback = await _apiService.getFeedback(vendorId: widget.vendorId);
      
      setState(() {
        _vendor = vendor;
        _feedback = feedback;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Details'),
        backgroundColor: Colors.orange[600],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vendor == null
              ? const Center(child: Text('Vendor not found'))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.grey[300],
                        child: _vendor!.image != null
                            ? Image.network(
                                _vendor!.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.restaurant, size: 80),
                                  );
                                },
                              )
                            : Container(
                                child: const Icon(Icons.restaurant, size: 80),
                              ),
                      ),
                      // Business Info
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _vendor!.businessName,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (_vendor!.verified)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.verified, size: 14, color: Colors.green[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.green[600],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _vendor!.category,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Rating
                            Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: _vendor!.avgRating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 20,
                                  ignoreGestures: true,
                                  itemBuilder: (context, _) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (_) {},
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${_vendor!.avgRating.toStringAsFixed(1)} (${_vendor!.totalRatings})',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Location
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _vendor!.location,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(Icons.map, color: Colors.orange),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Service Area: ${_vendor!.serviceArea}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Description
                            if (_vendor!.description != null) ...[
                              Text(
                                'About',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _vendor!.description!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            // Menu Items
                            if (_vendor!.menuItems != null && _vendor!.menuItems!.isNotEmpty) ...[
                              Text(
                                'Menu',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _vendor!.menuItems!.length,
                                itemBuilder: (context, index) {
                                  final item = _vendor!.menuItems![index];
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.dishName,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  item.category,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            '₹${item.price}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            // Feedback Section
                            if (_feedback.isNotEmpty) ...[
                              Text(
                                'Customer Reviews',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _feedback.length,
                                itemBuilder: (context, index) {
                                  final feedback = _feedback[index];
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: feedback.rating.toDouble(),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemCount: 5,
                                            itemSize: 16,
                                            ignoreGestures: true,
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (_) {},
                                          ),
                                          const SizedBox(height: 8),
                                          Text(feedback.comment),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: _vendor != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                text: 'Book Now',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingScreen(vendor: _vendor!),
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }
}
