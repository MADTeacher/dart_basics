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

// вспомогательная функция для добавления группы со студентами
Future<void> addStudentGroup(
  AppDatabase db,
  String groupName,
  List<String> students,
) async {
  var groupId = await db.into(db.groups).insert(
        GroupsCompanion.insert(
          name: groupName,
        ),
      );
  print('Группа создана с ID: $groupId');
  for (var student in students) {
    var studentId = await db.into(db.students).insert(
          StudentsCompanion.insert(
            fullName: student,
            groupId: groupId,
          ),
        );
    print('Студент $student с ID: $studentId добавлен в группу');
  }
}

void main() async {
  final appDocumentsDir = Directory.current;

  // Создаем путь до базы данных в корневой каталог
  String dbPath = path.join(appDocumentsDir.path, "app.db");
  final db = AppDatabase(dbPath);

  await addStudentGroup(
    db,
    'Group 1',
    ['Иванов Иван Иванович', 'Петрова Мария Сергеевна'],
  );
  await addStudentGroup(
    db,
    'Group 2',
    ['Мартынов Сергей Иванович', 'Петрова Анна Валерьевна'],
  );
  await addStudentGroup(
    db,
    '4319',
    ['Мурашев Сергей Сергеевич', 'Пимкина Анна Валерьевна'],
  );

  await db.close();
}
