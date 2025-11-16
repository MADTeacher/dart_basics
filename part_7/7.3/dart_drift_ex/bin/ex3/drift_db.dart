import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

// Посредством механизма part of объявляем
// файл drift_db.g.dart как часть текущего файла.
// В нем будет генерироваться код,
// необходимый для работы с базой данных
part 'drift_db.g.dart';

// Таблица групп студентов
class Groups extends Table {
  // Определяем целочисленное поле для идентификатора группы
  IntColumn get id => integer()();
  // Определяем текстовое поле для названия группы,
  // ограничивая его длину от 1 до 15 символов
  TextColumn get name => text().withLength(min: 1, max: 15)();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}

// Таблица студентов
class Students extends Table {
  // Определяем целочисленное поле для идентификатора студента
  IntColumn get id => integer()();
  // Определяем текстовое поле для полного имени студента,
  // ограничивая его длину от 1 до 50 символов
  TextColumn get fullName => text().withLength(min: 1, max: 50)();
  // Определяем целочисленное поле для идентификатора группы,
  // ссылаясь на таблицу Groups (связь многие-к-одному)
  IntColumn get groupId => integer().references(
        Groups,
        #id,
        // При удалении группы автоматически удалятся
        // все связанные с ней студенты
        onDelete: KeyAction.cascade,
      )();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}

// @DriftDatabase - декоратор, указывающий на таблицы,
// которые будут использоваться в базе данных
@DriftDatabase(tables: [Groups, Students])
class AppDatabase extends _$AppDatabase {
  // Создаем конструктор базы данных,
  // передавая в конструктор базового класса
  // функцию открытия подключения
  AppDatabase(String dbPath) : super(_openConnection(dbPath));

  // Определяем версию схемы базы данных
  @override
  int get schemaVersion => 1;

  // Определяем стратегию миграции
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      // Включаем поддержку внешних ключей при открытии существующей базы
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }

  // Статический метод для открытия подключения к базе данных
  static QueryExecutor _openConnection(String dbPath) {
    return NativeDatabase.createInBackground(File(dbPath));
  }
}

// Пользовательская модель для результатов запроса
final class MyModel {
  final int studentId;
  final String fullName;
  final String groupName;
  MyModel({
    required this.studentId,
    required this.fullName,
    required this.groupName,
  });

  @override
  String toString() {
    return 'MyModel(studentId: $studentId, fullName: '
        '$fullName, groupName: $groupName)';
  }
}

void main() async {
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных в корневой каталог
  String dbPath = path.join(appDocumentsDir.path, "app.db");
  final db = AppDatabase(dbPath);

  // Вывести всех студентов
  var students = await db.select(db.students).get();
  print(students);

  print('\nСписок студентов и их идентификаторов, без id_group:');
  var studentsNames = await db
      .select(db.students)
      .map((student) => {student.fullName, student.id})
      .get();
  print(studentsNames);

  print('\nСтуденты, чья фамилия начинается на "М":');
  var studentsWithM = await (db.select(db.students)
        ..where((student) => student.fullName.like('М%')))
      .map((student) => {student.fullName, student.id})
      .get();
  print(studentsWithM);

  print('\nВыводим id_студента, ФИО, имя №_группы,');
  print('где группа с id_группы = 4319:');
  // Формируем запрос с использованием join для
  // получения id_студента, ФИО и имени группы
  var query = db
      .select(db.students)
      .join([innerJoin(db.groups, db.groups.id.equalsExp(db.students.groupId))])
    ..where(db.groups.name.equals('4319'));
  // Выполняем запрос и выводим результат
  var result = await query
      .map((row) => {
            row.readTable(db.students).id,
            row.readTable(db.students).fullName,
            row.readTable(db.groups).name
          })
      .get();
  print(result);

  // переупакевываем результат в список map
  var resultList = await query
      .map((row) => {
            'student_id': row.readTable(db.students).id,
            'full_name': row.readTable(db.students).fullName,
            'group_name': row.readTable(db.groups).name
          })
      .get();
  print(resultList);

  // переупаковываем результат в список Record
  var resultRecords = await query
      .map((row) => (
            studentId: row.readTable(db.students).id,
            fullName: row.readTable(db.students).fullName,
            groupName: row.readTable(db.groups).name
          ))
      .get();
  print(resultRecords);
  print(resultRecords[0].studentId);
  print(resultRecords[0].fullName);
  print(resultRecords[0].groupName);

  // переупаковываем результат в пользовательскую модель
  var resultModels = await query
      .map((row) => MyModel(
          studentId: row.readTable(db.students).id,
          fullName: row.readTable(db.students).fullName,
          groupName: row.readTable(db.groups).name))
      .get();
  print(resultModels);

  print('\nКоличество студентов в каждой группе:');
  // Формируем запрос с использованием selectOnly для
  // получения количества студентов в каждой группе
  var studentsCount = await (db.selectOnly(db.students)
        // Добавляем столбцы для названия группы и количества студентов
        // и группируем по идентификатору группы
        ..addColumns([db.groups.name, db.students.id.count()])
        ..groupBy([db.students.groupId]))
      // Соединяем таблицы groups и students по идентификатору группы
      .join([
        innerJoin(db.groups, db.groups.id.equalsExp(db.students.groupId)),
      ])
      // Переупаковываем результат в список map
      .map((row) => {
            'group_name': row.read(db.groups.name)!,
            'students_count': row.read(db.students.id.count())!
          })
      .get();
  print(studentsCount);

  await db.close();
}
