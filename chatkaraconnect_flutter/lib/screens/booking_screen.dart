import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/vendor.dart';
import '../widgets/custom_widgets.dart';

class BookingScreen extends StatefulWidget {
  final Vendor vendor;

  const BookingScreen({Key? key, required this.vendor}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _apiService = ApiService();
  final _eventTypeController = TextEditingController();
  final _guestsController = TextEditingController();
  final _budgetController = TextEditingController();
  DateTime? _selectedDate;
  bool _isLoading = false;
  int? _customerId;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    _customerId = int.tryParse(prefs.getString('user_id') ?? '0');
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submitBooking() async {
    if (_eventTypeController.text.isEmpty ||
        _guestsController.text.isEmpty ||
        _budgetController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final order = await _apiService.createOrder(
        customerId: _customerId ?? 0,
        vendorId: widget.vendor.id,
        eventType: _eventTypeController.text,
        eventDate: _selectedDate!,
        guests: int.parse(_guestsController.text),
        totalPrice: double.parse(_budgetController.text),
      );

      if (order != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking successful!')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _eventTypeController.dispose();
    _guestsController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.vendor.businessName}'),
        backgroundColor: Colors.orange[600],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vendor Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: widget.vendor.image != null
                            ? Image.network(
                                widget.vendor.image!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.restaurant),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.vendor.businessName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.vendor.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${widget.vendor.avgRating}/5 rating',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Event Type',
                hint: 'e.g., Wedding, Birthday, Corporate',
                controller: _eventTypeController,
              ),
              const SizedBox(height: 20),
              Text(
                'Event Date',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : DateFormat('dd MMM yyyy').format(_selectedDate!),
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.orange),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Number of Guests',
                hint: 'e.g., 50',
                controller: _guestsController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: 'Budget (Estimated)',
                hint: 'e.g., 50000',
                controller: _budgetController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Confirm Booking',
                isLoading: _isLoading,
                onPressed: _submitBooking,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
