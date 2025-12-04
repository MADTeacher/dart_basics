import 'interfaces/i_database_provider.dart';
import 'interfaces/i_group_dao.dart';
import 'interfaces/i_student_dao.dart';
import 'interfaces/i_discipline_dao.dart';
import 'interfaces/i_missed_class_dao.dart';
import 'dao_adapter/group.dart';
import 'dao_adapter/student.dart';
import 'dao_adapter/discipline.dart';
import 'dao_adapter/missed_class.dart';
import 'drift_database.dart';

class SqliteDatabase implements IDatabaseProvider {
  final AppDatabase _db;
  late final GroupDaoAdapter _groupDao;
  late final StudentDaoAdapter _studentDao;
  late final DisciplineDaoAdapter _disciplineDao;
  late final MissedClassDaoAdapter _missedClassDao;

  SqliteDatabase._(this._db) {
    _groupDao = GroupDaoAdapter(_db.groupDao);
    _studentDao = StudentDaoAdapter(_db.studentDao);
    _disciplineDao = DisciplineDaoAdapter(_db.disciplineDao);
    _missedClassDao = MissedClassDaoAdapter(_db.missedClassDao);
  }

  static Future<SqliteDatabase> create(String dbName) async {
    final db = AppDatabase(dbName);
    return SqliteDatabase._(db);
  }

  @override
  IGroupDao get groupDao => _groupDao;

  @override
  IStudentDao get studentDao => _studentDao;

  @override
  IDisciplineDao get disciplineDao => _disciplineDao;

  @override
  IMissedClassDao get missedClassDao => _missedClassDao;

  @override
  Future<void> close() async {
    await _db.close();
  }
}
