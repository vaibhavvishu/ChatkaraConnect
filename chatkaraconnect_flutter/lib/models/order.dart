class Order {
  final int id;
  final int customer;
  final String customerName;
  final int vendor;
  final String vendorName;
  final String eventType;
  final DateTime eventDate;
  final int guests;
  final double totalPrice;
  final String status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.customer,
    required this.customerName,
    required this.vendor,
    required this.vendorName,
    required this.eventType,
    required this.eventDate,
    required this.guests,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      customer: json['customer'] ?? 0,
      customerName: json['customer_name'] ?? '',
      vendor: json['vendor'] ?? 0,
      vendorName: json['vendor_name'] ?? '',
      eventType: json['event_type'] ?? '',
      eventDate: DateTime.parse(json['event_date'] ?? DateTime.now().toString()),
      guests: json['guests'] ?? 0,
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer': customer,
      'vendor': vendor,
      'event_type': eventType,
      'event_date': eventDate.toIso8601String().split('T')[0],
      'guests': guests,
      'total_price': totalPrice,
      'status': status,
    };
  }
}
