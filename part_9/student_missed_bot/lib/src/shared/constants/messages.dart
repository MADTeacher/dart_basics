// Текстовые константы для сообщений бота
class BotMessages {
  // Общие сообщения
  static const unauthorizedAccess = 'Ты кто? Оо';
  static const startMessage = '<b>Поехали!!!</b>';

  // Меню
  static const presenceCheck = 'Проверка присутствия';
  static const shortReport = 'Краткий отчет';
  static const fullReport = 'Полный отчет';
  static const interactiveReport = 'Интерактивный отчет';

  // Группы
  static const selectGroup = 'Выберете группу:';
  static const enterGroupName = 'Введите название группы:';
  static const groupAlreadyExists = 'Группа с таким названием уже существует';
  static const groupAdded = 'Группа успешно добавлена';

  // Дисциплины
  static const selectDiscipline = 'Выберете дисциплину:';
  static const enterDisciplineName = 'Введите название дисциплины:';
  static const disciplineAlreadyExists =
      'Дисциплина с таким названием уже существует';
  static const disciplineAdded = 'Дисциплина успешно добавлена';
  static const disciplineAssigned = 'Дисциплина назначена группе';
  static const noGroupsToAssign = 'Нет групп для назначения';
  static const selectSubject = 'Выберете предмет';

  // Студенты
  static const enterStudentName = 'Введите ФИО студента';
  static const invalidNameFormat =
      'Пожалуйста, введите ФИО формате: Иванов Иван Иванович';
  static const selectStudentToDelete = 'Выберете удаляемого студента';
  static const studentDeleted = 'Студент удален';
  static const selectStudent = 'Выберете студента';
  static const studentAdded = 'Студент успешно добавлен';

  // Проверка присутствия
  static const selectAbsentStudent = 'Выберите отсутствующего студента:';
  static const allPresent = 'Все студенты присутствуют на занятии!!!';
  static const allAbsent = 'На паре нет ни одного студента!!!';
  static const attendanceRecorded = 'Все опаздашкинсы зафиксированы!!!';

  // Отчеты
  static const startingReport = 'Начинаем формировать отчет';
  static const reportReady = 'Отчет успешно сформирован';
  static const noAssignedDisciplines = 'За группой не числится дисциплин';

  // Ошибки
  static const unknownDataFormat = 'Неизвестный формат для обработки данных';
}
