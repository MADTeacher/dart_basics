// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      name: json['name'] as String,
      budget: json['budget'] as int,
      actors: (json['actors'] as List<dynamic>)
          .map((e) => Actor.fromJson(e as Map<String, dynamic>))
          .toList(),
      criticsRating: (json['criticsRating'] as num).toDouble(),
      audienceRating: (json['audienceRating'] as num).toDouble(),
      year: json['year'] as int,
      country: json['country'] as String,
      genre: Genre.fromJson(json['genre'] as List<dynamic>),
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'name': instance.name,
      'budget': instance.budget,
      'actors': instance.actors,
      'criticsRating': instance.criticsRating,
      'audienceRating': instance.audienceRating,
      'year': instance.year,
      'country': instance.country,
      'genre': instance.genre,
      'reviews': instance.reviews,
    };
