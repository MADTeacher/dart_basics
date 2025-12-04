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

// Меняем ФИО студента и переводим его в другую группу
Future<void> changeStudentName(
  AppDatabase db,
  String oldName,
  String newName,
  int newGroupId,
) async {
  await (db.update(db.students)
        ..where(
          (u) => u.fullName.equals(oldName),
        ))
      .write(
    StudentsCompanion(
      fullName: Value(newName),
      groupId: Value(newGroupId),
    ),
  );
}

// Меняем имя группы
Future<void> changeGroupName(
  AppDatabase db,
  String oldName,
  String newName,
) async {
  await (db.update(db.groups)
        ..where(
          (u) => u.name.equals(oldName),
        ))
      .write(
    GroupsCompanion(
      name: Value(newName),
    ),
  );
}

// Выводим всех студентов и их группы
Future<void> printAllStudents(AppDatabase db) async {
  print('\nВыводим id_студента, ФИО, имя №_группы,');
  var query = db.select(db.students).join(
      [innerJoin(db.groups, db.groups.id.equalsExp(db.students.groupId))]);
  var result = await query
      .map((row) => {
            row.readTable(db.students).id,
            row.readTable(db.students).fullName,
            row.readTable(db.groups).name
          })
      .get();
  print(result);
}

// Выводим количество студентов в каждой группе
Future<void> printStudentsCount(AppDatabase db) async {
  print('\nКоличество студентов в каждой группе:');
  var studentsCount = await (db.selectOnly(db.students)
        ..addColumns([db.groups.name, db.students.id.count()])
        ..groupBy([db.students.groupId]))
      .join([
        innerJoin(db.groups, db.groups.id.equalsExp(db.students.groupId)),
      ])
      .map((row) => {
            'group_name': row.read(db.groups.name)!,
            'students_count': row.read(db.students.id.count())!
          })
      .get();
  print(studentsCount);
}

void main() async {
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных в корневой каталог
  String dbPath = path.join(appDocumentsDir.path, "app.db");
  final db = AppDatabase(dbPath);

  // Меняем имя Group 1 на 4317
  await changeGroupName(db, 'Group 1', '4317');

  // Меняем имя Group 2 на 4318
  await changeGroupName(db, 'Group 2', '4318');

  // Ищем группу 4318
  final group = await (db.select(db.groups)
        ..where((gr) => gr.name.equals('4318')))
      .getSingle();

  // Меняем Пимкина Анна Валерьевна на Петрова Анна Валерьевна
  // и переводим ее в группу 4318
  await changeStudentName(
    db,
    'Пимкина Анна Валерьевна',
    'Петрова Анна Валерьевна',
    group.id, // ID группы 4318
  );

  // Меняем Петрова Мария Сергеевна на Багдасарова Мария Сергеевна
  // и переводим ее в группу 4318
  await changeStudentName(
    db,
    'Петрова Мария Сергеевна',
    'Багдасарова Мария Сергеевна',
    group.id, // ID группы 4318
  );

  await printStudentsCount(db);
  await printAllStudents(db);
  await db.close();
}
