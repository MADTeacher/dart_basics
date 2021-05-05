import 'package:json_annotation/json_annotation.dart';

import 'student.dart';

part 'group.g.dart';

@JsonSerializable()
class Group{
  final String groupName;
  late int course;
  List<Student>? students = [];

  Group({required this.groupName, 
         required this.course, this.students});

  Group.emptyGroup({required this.groupName, 
                                 required this.course});

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
  Map<String, dynamic> toJson() => _$GroupToJson(this);

  int get amountStudents{
    return students?.length ?? 0;
  }

  void addStudent(Student student){
    students?.add(student);
  }

  void addAllStudents(List<Student> students){
    this.students?.addAll(students);
  }

  @override
  String toString() {
    var groupInfo = 'Группа: $groupName \nкурс: $course\n';
    groupInfo += 'кол-во студентов: $amountStudents \nсписок: [ \n';
    students?.forEach((element) {
      groupInfo += '$element \n';
    });
    groupInfo += ']';
    return  groupInfo;
  }
}
