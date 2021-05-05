import 'dart:convert';
import 'dart:io';

class Student {
  final String name;
  late int age;
  late int course;
  late bool single;
  List<String> _descriptionList = [];

  Student(
      {required this.name,
      required this.age,
      required this.course,
      required this.single});

  Student.fromJson(Map<String, dynamic> json)
   :name = json['name']{
    age = json['age'];
    course = json['course'];
    single = json['single'];
    _descriptionList = List<String>.from(json['description']);
  }

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

void main() {
  print('Запуск main');
  startHTTPServer();
  print('Завершение main');
}

void startHTTPServer() {
  var student = Student(name: 'Alex', age: 19, course: 1, single: false);
  var descriptions = ['Мечтатель', 'Ленив', 'Студент'];
  student.addAllDescriptions(descriptions);
  student.addDescription('Постоянно жалуется на жизнь');
  var encoder = JsonEncoder.withIndent('  ');
  var answer = encoder.convert(student);

  HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server) {
    server.listen((HttpRequest request) {
      print(request.uri.path);
      if (request.uri.path.startsWith('/student')) {
        request.response.write(answer);
        request.response.close();
      } else if(request.uri.path.startsWith('/hello')){
        request.response.write('Добро пожаловать на сервер!');
        request.response.close();
      }else{
        request.response.write('Дратути!');
        request.response.close();
      }
    });
  });
}

