class Payment {
  final int id;
  final int order;
  final double amount;
  final String paymentMethod;
  final String paymentStatus;

  Payment({
    required this.id,
    required this.order,
    required this.amount,
    required this.paymentMethod,
    required this.paymentStatus,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] ?? 0,
      order: json['order'] ?? 0,
      amount: (json['amount'] ?? 0).toDouble(),
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'amount': amount,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
    };
  }
}
