class Feedback {
  final int id;
  final int order;
  final int rating;
  final String comment;

  Feedback({
    required this.id,
    required this.order,
    required this.rating,
    required this.comment,
  });

  factory Feedback.fromJson(Map<String, dynamic> json) {
    return Feedback(
      id: json['id'] ?? 0,
      order: json['order'] ?? 0,
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order': order,
      'rating': rating,
      'comment': comment,
    };
  }
}
