import 'dart:convert';
import 'dart:io';

import 'student.dart';
import 'group.dart';

void main(List<String> arguments) {
  // формируем фгуппу из нескольких студентов
  var studentsGroup = Group.emptyGroup(groupName: '1-МД-66', 
     course: 1);
var firstStudent = Student.withOutDescription(name: 'Alex', 
age: 19, course: 1, single: false);
  var descriptions = ['Мечтатель', 'Ленив', 'Студент'];
  firstStudent.addAllDescriptions(descriptions);
  firstStudent.addDescription('Постоянно жалуется на жизнь');
  var secondStudent = Student('Maxim',22, 1,true, descriptions);
  secondStudent.addDescription('Девиз: всё нормально!');
  studentsGroup.addAllStudents(<Student>[firstStudent, secondStudent]);
  
  // сериализуем группу в json
  var encoder = JsonEncoder.withIndent('  ');
  var test = encoder.convert(studentsGroup);
  
  var myFile = File('data/group.json');
  myFile.createSync(recursive: true);
  myFile.writeAsStringSync(test); // записываем в файл
  
  // десериализуем данные и выводим в терминал
  var newStudentsGroup = Group.fromJson(jsonDecode(test));
  print(newStudentsGroup);
}
