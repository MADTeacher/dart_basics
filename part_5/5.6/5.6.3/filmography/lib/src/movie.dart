import 'package:json_annotation/json_annotation.dart';

import 'actor.dart';
import 'genre.dart';
import 'review.dart';

part 'movie.g.dart';

@JsonSerializable()
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

  Movie({
    required this.name,
    required this.budget,
    required this.actors,
    required this.criticsRating,
    required this.audienceRating,
    required this.year,
    required this.country,
    required this.genre,
    required this.reviews,
  });

  factory Movie.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);

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
