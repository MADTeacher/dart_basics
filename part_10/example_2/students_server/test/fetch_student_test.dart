import 'package:test/test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../lib/students_server.dart';
// файл, который будет сгенерирован
import 'fetch_student_test.mocks.dart';

// аннотация для указания на основе какого
// класса генерировать фиктивный объект
@GenerateMocks([http.Client])
void main() {
  final id = 10;
  late http.Client client;

  setUp(() {
    // Create mock object.
    client = MockClient();
  });

  test('Получение данных о студенте и проверка их распаковки', 
  ()async {
    when(client.get(Uri.https('www.students-db.org', 
      '/students', {'q': id.toString()})))
      .thenAnswer((_) async => 
         http.Response('{ "name": "Alex", "age": 19, "course": 1}', 200));
    // Проверка возвращается ли экземпляр класса Student
    var student = await fetchStudent(client, id);
    expect(student, isA<Student>());
    // Корректно ли имя студента?
    expect(student.name, 'Alex');
    //Возраст?
    expect(student.age, 19);
    //Курс?
    expect(student.course, 1);
  });

  test('Проверка нештатной ситуации', 
  ()async {
    when(client.get(Uri.https('www.students-db.org', 
      '/students', {'q': id.toString()})))
      .thenAnswer((_) async => 
         http.Response('Ошибка на стороне сервера', 500));
    expect(() => fetchStudent(client, id), throwsArgumentError);
  });
}