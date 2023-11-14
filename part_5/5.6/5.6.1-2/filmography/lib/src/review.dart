class Review {
  final String name;
  final String? text;
  final double rating;

  Review({
    required this.name,
    required this.text,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'name': String name,
          'rating': double rating,
        }) {
      final text = json['text'] as String?;
      return Review(
        name: name,
        text: text ?? '',
        rating: rating,
      );
    } else {
      throw FormatException('Invalid JSON: $json');
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'text': text,
        'rating': rating,
      };

  @override
  String toString() {
    return 'Review{name: $name, text: $text, rating: $rating}';
  }
}
