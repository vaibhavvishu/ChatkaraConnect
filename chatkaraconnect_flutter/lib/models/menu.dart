class Menu {
  final int id;
  final int vendor;
  final String dishName;
  final double price;
  final String category;

  Menu({
    required this.id,
    required this.vendor,
    required this.dishName,
    required this.price,
    required this.category,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'] ?? 0,
      vendor: json['vendor'] ?? 0,
      dishName: json['dish_name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendor': vendor,
      'dish_name': dishName,
      'price': price,
      'category': category,
    };
  }
}
