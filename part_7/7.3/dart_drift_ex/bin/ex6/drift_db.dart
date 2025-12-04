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
  // Новые поля для миграции отмечаются как nullable, 
  // так как добавляются к уже существующей БД
  TextColumn get email => text().nullable()();
  TextColumn get phone => text().nullable()();

  // Определяем пользовательский первичный ключ
  @override
  Set<Column<Object>> get primaryKey => {id};
}

// @DriftDatabase - декоратор, указывающий на таблицы,
// которые будут использоваться в базе данных
@DriftDatabase(tables: [Groups, Students])
class AppDatabase extends _$AppDatabase {
  final int sVersion;
  // Создаем конструктор базы данных,
  // передавая в конструктор базового класса
  // функцию открытия подключения
  AppDatabase(String dbPath, {this.sVersion = 1})
      : super(_openConnection(dbPath));

  // Определяем версию схемы базы данных
  @override
  int get schemaVersion => sVersion;

  // Определяем стратегию миграции
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      // Выполняется при изменении версии базы данных
      onUpgrade: (Migrator m, int from, int to) async {
        print('onUpgrade вызван: from=$from, to=$to');
        await m.addColumn(students, students.email);
        await m.addColumn(students, students.phone);

          // Обновляем запись для Иванова
          await (update(students)
                ..where((tbl) =>
                    tbl.fullName.equals('Иванов Иван Иванович')))
              .write(
            const StudentsCompanion(
              email: Value('ivanov@ii.com'),
              phone: Value('+79991234567'),
            ),
          );
       
      },
      // Включаем поддержку внешних ключей при создании базы данных
      // Выполняется только при создании новой базы данных
      onCreate: (Migrator m) async {
        // Создаем все таблицы
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

Future<void> openAndPrintDatabase(String dbPath, int version) async {
  final db = AppDatabase(dbPath, sVersion: version);
  final studentsList = await db.select(db.students).get();
  print('Текущая версия схемы: $version');
  print(studentsList);
  await db.close();
}

void main() async {
  final appDocumentsDir = Directory.current;
  final dbPath = path.join(appDocumentsDir.path, "app.db");

  print('\n=== Запускаем миграцию на 2-ю версию ===');
  await openAndPrintDatabase(dbPath, 2);
}


