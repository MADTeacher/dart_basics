import 'dart:convert';
import 'dart:io';

class Student {
  final String name;
  int age;
  int course;
  bool single;
  List<String> _descriptionList = [];

  Student(
      {required this.name,
      required this.age,
      required this.course,
      required this.single});

  void addDescription(String description) {
    _descriptionList.add(description);
  }

  void addAllDescriptions(List<String> descriptions) {
    _descriptionList.addAll(descriptions);
  }

  @override
  String toString() {
    var student = 'Студент {имя: $name, возраст: $age, ';
    student += 'курс: $course, холост: $single, ';
    student +=  'описание: $_descriptionList}';
    return  student;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'course': course,
      'single': single,
      'description': _descriptionList
    };
  }
}

void main() async {
  var myFile = File('data/student.json');
  var student = Student(name: 'Alex', age: 19, course: 1, single: false);
  var descriptions = ['Мечтатель', 'Ленив', 'Студент'];
  student.addAllDescriptions(descriptions);
  student.addDescription('Постоянно жалуется на жизнь');
  print(student);
  // Код ниже автоматически вызывает метод toJson у
  // передаваемого на вход экземпляра класса Student
  myFile.createSync(recursive: true);
  var encoder = JsonEncoder.withIndent('  ');
  myFile.writeAsStringSync(encoder.convert(student));
  print(myFile.readAsStringSync());
} 
