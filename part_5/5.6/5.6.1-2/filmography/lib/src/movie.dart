import 'actor.dart';
import 'genre.dart';
import 'review.dart';

class Movie {
  final String name;
  final int budget;
  final List<Actor> actors;
  final double criticsRating;
  final double audienceRating;
  final int year;
  final String country;
  final Genre genre;
  final List<Review> reviews;

  Movie(
      {required this.name,
      required this.budget,
      required this.actors,
      required this.criticsRating,
      required this.audienceRating,
      required this.year,
      required this.country,
      required this.genre,
      required this.reviews});

  factory Movie.fromJson(Map<String, dynamic> json) {
    if (json
        case {
          'name': String name,
          'budget': int budget,
          'actors': List<dynamic> actors,
          'criticsRating': double criticsRating,
          'audienceRating': double audienceRating,
          'year': int year,
          'country': String country,
          'genre': List<dynamic> genre,
          'reviews': List<dynamic> reviews,
        }) {
      return Movie(
        name: name,
        budget: budget,
        actors: actors.map((e) => Actor.fromJson(e)).toList(),
        criticsRating: criticsRating,
        audienceRating: audienceRating,
        year: year,
        country: country,
        genre: Genre(genre.map((e) => e as String).toList()),
        reviews: reviews.map((e) => Review.fromJson(e)).toList(),
      );
    } else {
      throw FormatException('Invalid JSON: $json');
    }
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'budget': budget,
        'actors': actors,
        'criticsRating': criticsRating,
        'audienceRating': audienceRating,
        'year': year,
        'country': country,
        'genre': genre,
        'reviews': reviews
      };

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write('Movie{name: $name, budget: $budget, ');
    sb.write('actors: $actors, criticsRating: $criticsRating, ');
    sb.write('audienceRating: $audienceRating, year: $year, ');
    sb.write('country: $country, genre: $genre, reviews: $reviews}');
    return sb.toString();
  }
}
