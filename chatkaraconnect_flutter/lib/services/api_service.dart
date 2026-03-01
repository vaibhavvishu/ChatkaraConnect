import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_config.dart';
import '../models/user.dart';
import '../models/vendor.dart';
import '../models/order.dart';
import '../models/feedback.dart';
import '../models/payment.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  // ===== USER ENDPOINTS =====
  Future<User?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}login/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  Future<User?> registerUser(
    String name,
    String email,
    String phone,
    String password,
    String role,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.usersEndpoint}register/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return User.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // ===== VENDOR ENDPOINTS =====
  Future<List<Vendor>> getVendors({String? search}) async {
    try {
      String url = '${ApiConfig.baseUrl}${ApiConfig.vendorsEndpoint}';
      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      final response = await http.get(Uri.parse(url)).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'] ?? jsonData;
        
        return List<Vendor>.from(results.map((x) => Vendor.fromJson(x)));
      }
      return [];
    } catch (e) {
      print('Get vendors error: $e');
      return [];
    }
  }

  Future<Vendor?> getVendorDetail(int vendorId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.vendorsEndpoint}$vendorId/'),
      ).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        return Vendor.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Get vendor detail error: $e');
      return null;
    }
  }

  Future<bool> registerVendor({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String businessName,
    required String location,
    required String category,
    String? serviceArea,
    String? description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.vendorsEndpoint}register_vendor/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': {
            'name': name,
            'email': email,
            'phone': phone,
            'password': password,
          },
          'vendor': {
            'business_name': businessName,
            'location': location,
            'service_area': serviceArea ?? '',
            'category': category,
            'description': description ?? '',
          }
        }),
      ).timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 201;
    } catch (e) {
      print('Register vendor error: $e');
      return false;
    }
  }

  // ===== ORDER ENDPOINTS =====
  Future<List<Order>> getOrders({int? customerId, int? vendorId, String? status}) async {
    try {
      String url = '${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}';
      List<String> params = [];
      
      if (customerId != null) params.add('customer=$customerId');
      if (vendorId != null) params.add('vendor=$vendorId');
      if (status != null && status.isNotEmpty) params.add('status=$status');

      if (params.isNotEmpty) {
        url += '?${params.join('&')}';
      }

      final response = await http.get(Uri.parse(url)).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'] ?? jsonData;
        
        return List<Order>.from(results.map((x) => Order.fromJson(x)));
      }
      return [];
    } catch (e) {
      print('Get orders error: $e');
      return [];
    }
  }

  Future<Order?> createOrder({
    required int customerId,
    required int vendorId,
    required String eventType,
    required DateTime eventDate,
    required int guests,
    required double totalPrice,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'customer': customerId,
          'vendor': vendorId,
          'event_type': eventType,
          'event_date': eventDate.toIso8601String().split('T')[0],
          'guests': guests,
          'total_price': totalPrice,
          'status': 'pending',
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return Order.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Create order error: $e');
      return null;
    }
  }

  Future<bool> updateOrderStatus(int orderId, String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.ordersEndpoint}$orderId/update_status/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      ).timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      print('Update order status error: $e');
      return false;
    }
  }

  // ===== FEEDBACK ENDPOINTS =====
  Future<List<Feedback>> getFeedback({int? vendorId}) async {
    try {
      String url = '${ApiConfig.baseUrl}${ApiConfig.feedbackEndpoint}';
      if (vendorId != null) {
        url += '?vendor=$vendorId';
      }

      final response = await http.get(Uri.parse(url)).timeout(ApiConfig.receiveTimeout);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        List<dynamic> results = jsonData['results'] ?? jsonData;
        
        return List<Feedback>.from(results.map((x) => Feedback.fromJson(x)));
      }
      return [];
    } catch (e) {
      print('Get feedback error: $e');
      return [];
    }
  }

  Future<Feedback?> createFeedback(int orderId, int rating, String comment) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.feedbackEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order': orderId,
          'rating': rating,
          'comment': comment,
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return Feedback.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Create feedback error: $e');
      return null;
    }
  }

  // ===== PAYMENT ENDPOINTS =====
  Future<Payment?> createPayment(int orderId, double amount, String paymentMethod) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.paymentsEndpoint}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'order': orderId,
          'amount': amount,
          'payment_method': paymentMethod,
          'payment_status': 'pending',
        }),
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 201) {
        return Payment.fromJson(jsonDecode(response.body));
      }
      return null;
    } catch (e) {
      print('Create payment error: $e');
      return null;
    }
  }

  Future<bool> confirmPayment(int paymentId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.paymentsEndpoint}$paymentId/confirm_payment/'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(ApiConfig.connectionTimeout);

      return response.statusCode == 200;
    } catch (e) {
      print('Confirm payment error: $e');
      return false;
    }
  }
}
