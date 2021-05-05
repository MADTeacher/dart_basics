import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart'; // сюда будет сгенерирован
                       // код сериализации/десериализации

@JsonSerializable()
class Student {
  final String name;
  late int age;
  late int course;
  late bool single;
  @JsonKey(name: 'description')
  List<String>? _descriptionList = [];

  Student(this.name, this.age, this.course, 
          this.single, List<String>? description){
            _descriptionList = description;
          }

  Student.withOutDescription(
      {required this.name,
      required this.age,
      required this.course,
      required this.single});

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);

  List<String> get description{
    return _descriptionList ?? <String>[];
  }

  void addDescription(String description) {
    _descriptionList?.add(description);
  }

  void addAllDescriptions(List<String> descriptions) {
    _descriptionList?.addAll(descriptions);
  }

  @override
  String toString() {
    var student = 'Студент {имя: $name, возраст: $age, ';
    student += 'курс: $course, холост: $single, ';
    student +=  'описание: $_descriptionList}';
    return  student;
  }
}
