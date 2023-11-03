// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Actor _$ActorFromJson(Map<String, dynamic> json) => Actor(
      name: json['name'] as String,
      age: json['age'] as int,
      numberOfFilms: json['filmsAmount'] as int,
      aboutActor: json['aboutActor'] as String?,
    );

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'filmsAmount': instance.numberOfFilms,
      'aboutActor': instance.aboutActor,
    };
