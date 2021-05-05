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
  startUDPServer();
  print('Завершение main');
}

// UDP
void startUDPServer() async {
  var rawDgramSocket =
      await RawDatagramSocket.bind(InternetAddress.loopbackIPv4, 8083);
  await for (RawSocketEvent event in rawDgramSocket) {
    if (event == RawSocketEvent.read) {
      var datagram = rawDgramSocket.receive();
      var json = utf8.decode(datagram!.data);
      print(json);
      var student = Student.fromJson(jsonDecode(json));
      print(student);
      rawDgramSocket.send(
          utf8.encode('Hello, Client'), InternetAddress.loopbackIPv4, 8084);
      rawDgramSocket.close();
      exit(0);
    }
  }
}
