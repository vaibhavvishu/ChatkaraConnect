import 'user.dart';
import 'menu.dart';

class Vendor {
  final int id;
  final User user;
  final String businessName;
  final String location;
  final String serviceArea;
  final String category;
  final bool verified;
  final String? description;
  final String? image;
  final double avgRating;
  final int totalRatings;
  final List<Menu>? menuItems;

  Vendor({
    required this.id,
    required this.user,
    required this.businessName,
    required this.location,
    required this.serviceArea,
    required this.category,
    required this.verified,
    this.description,
    this.image,
    required this.avgRating,
    required this.totalRatings,
    this.menuItems,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    var menuList = <Menu>[];
    if (json['menu_items'] != null) {
      menuList = List<Menu>.from(
        (json['menu_items'] as List).map((x) => Menu.fromJson(x)),
      );
    }

    return Vendor(
      id: json['id'] ?? 0,
      user: User.fromJson(json['user'] ?? {}),
      businessName: json['business_name'] ?? '',
      location: json['location'] ?? '',
      serviceArea: json['service_area'] ?? '',
      category: json['category'] ?? '',
      verified: json['verified'] ?? false,
      description: json['description'],
      image: json['image'],
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      menuItems: menuList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_name': businessName,
      'location': location,
      'service_area': serviceArea,
      'category': category,
      'description': description,
      'verified': verified,
    };
  }
}
