import 'package:json_annotation/json_annotation.dart';

part 'actor.g.dart'; // сюда будет сгенерирован
                     // код сериализации/десериализации

@JsonSerializable()
class Actor {
  final String name;
  final int age;
  // устанавливаем соответствие ключа в JSON полю класса
  @JsonKey(name: 'filmsAmount')
  final int numberOfFilms;
  final String? aboutActor;

  Actor({
    required this.name,
    required this.age,
    required this.numberOfFilms,
    required this.aboutActor,
  });

  // Подключение генерируемой функции к конструктору fromJson
  factory Actor.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ActorFromJson(json); 

  // Подключение генерируемой функции к методу toJson
  Map<String, dynamic> toJson() => _$ActorToJson(this);

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write('Actor{name: $name, age: $age, ');
    sb.write('filmsAmount: $numberOfFilms, ');
    sb.write('aboutActor: $aboutActor}');
    return sb.toString();
  }
}
