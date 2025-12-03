import 'i_group_dao.dart';
import 'i_student_dao.dart';
import 'i_discipline_dao.dart';
import 'i_missed_class_dao.dart';

// Интерфейс провайдера базы данных
abstract interface class IDatabaseProvider {
  // DAO для работы с группами
  IGroupDao get groupDao;

  // DAO для работы со студентами
  IStudentDao get studentDao;

  // DAO для работы с дисциплинами
  IDisciplineDao get disciplineDao;

  // DAO для работы с пропусками
  IMissedClassDao get missedClassDao;

  // Закрываем соединение с базой данных
  Future<void> close();
}
