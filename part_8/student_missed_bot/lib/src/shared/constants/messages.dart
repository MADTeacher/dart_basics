/// Текстовые константы для сообщений бота
class BotMessages {
  // Общие сообщения
  static const String unauthorizedAccess = 'Ты кто? Оо';
  static const String startMessage = '<b>Поехали!!!</b>';

  // Меню
  static const String presenceCheck = 'Проверка присутствия';
  static const String shortReport = 'Краткий отчет';
  static const String fullReport = 'Полный отчет';
  static const String interactiveReport = 'Интерактивный отчет';

  // Группы
  static const String selectGroup = 'Выберете группу:';
  static const String enterGroupName = 'Введите название группы:';
  static const String groupAlreadyExists =
      'Группа с таким названием уже существует';
  static const String groupAdded = 'Группа успешно добавлена';

  // Дисциплины
  static const String selectDiscipline = 'Выберете дисциплину:';
  static const String enterDisciplineName = 'Введите название дисциплины:';
  static const String disciplineAlreadyExists =
      'Дисциплина с таким названием уже существует';
  static const String disciplineAdded = 'Дисциплина успешно добавлена';
  static const String disciplineAssigned = 'Дисциплина назначена группе';
  static const String noGroupsToAssign = 'Нет групп для назначения';
  static const String selectSubject = 'Выберете предмет';

  // Студенты
  static const String enterStudentName = 'Введите ФИО студента';
  static const String invalidNameFormat =
      'Пожалуйста, введите ФИО формате: Иванов Иван Иванович';
  static const String selectStudentToDelete = 'Выберете удаляемого студента';
  static const String studentDeleted = 'Студент удален';
  static const String selectStudent = 'Выберете студента';

  // Проверка присутствия
  static const String selectAbsentStudent = 'Выберите отсутствующего студента:';
  static const String allPresent = 'Все студенты присутствуют на занятии!!!';
  static const String allAbsent = 'На паре нет ни одного студента!!!';
  static const String attendanceRecorded = 'Все потеряшкинсы зафиксированы!!!';

  // Отчеты
  static const String startingReport = 'Начинаем формировать отчет';
  static const String reportReady = 'Отчет успешно сформирован';
  static const String noAssignedDisciplines =
      'За группой не числится дисциплин';

  // Ошибки
  static const String unknownDataFormat =
      'Неизвестный формат для обработки данных';
}
