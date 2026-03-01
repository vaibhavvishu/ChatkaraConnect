class ApiConfig {
  // Change this to your Django server URL
  static const String baseUrl = 'http://localhost:8000/api';
  
  // API Endpoints
  static const String vendorsEndpoint = '/vendors/';
  static const String usersEndpoint = '/users/';
  static const String ordersEndpoint = '/orders/';
  static const String menuEndpoint = '/menu/';
  static const String feedbackEndpoint = '/feedback/';
  static const String paymentsEndpoint = '/payments/';
  
  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
