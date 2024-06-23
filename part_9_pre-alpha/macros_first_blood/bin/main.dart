import 'package:json/json.dart';

@JsonCodable()
class Batman {
  final String name;
  final int age;

  Batman(this.name, this.age);

  @override
  String toString() {
    return 'Batman{name: $name, age: $age}';
  }
}


void main(List<String> arguments) {
  var batman = Batman('Bruce Wayne', 30);
  print(batman);

  final  json = <String, dynamic>{
    'name': 'Bruce Wayne',
    'age': 30
  };

  var macroBatman = Batman.fromJson(json);
  print(macroBatman);
  print(macroBatman.toJson());
}
