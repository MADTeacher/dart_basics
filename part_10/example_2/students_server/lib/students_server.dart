import 'dart:convert';

import 'package:http/http.dart' as http;

class Student {
  final String name;
  late int age;
  late int course;

  Student(
      {required this.name,
      required this.age,
      required this.course});

  Student.fromJson(Map<String, dynamic> json)
   :name = json['name']{
    age = json['age'];
    course = json['course'];
  }

  @override
  String toString() {
    var student = 'Студент {имя: $name, возраст: $age, ';
    student += 'курс: $course}';
    return  student;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'age': age,
      'course': course
    };
  }
}

Future<Student> fetchStudent(http.Client client, int id) async {

  final response = await client.get(Uri.https('www.students-db.org', 
      '/students', {'q': id.toString()}));
  
  if (response.statusCode == 200) {
    return Student.fromJson(json.decode(response.body));
  } else {
    throw Exception('Данные о студенте не загружены');
  }
}