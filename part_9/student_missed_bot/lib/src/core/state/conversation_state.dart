// Состояния бота для диалогов
enum BotState {
  idle,
  waitingGroupName,
  waitingDisciplineName,
  waitingStudentName,
}

// Данные состояния пользователя
class StateData {
  final BotState state;
  final Map<String, dynamic> data;

  StateData({required this.state, Map<String, dynamic>? data})
    : data = data ?? {};
}

// Класс для управления состояниями диалогов (in-memory)
class ConversationStateManager {
  // Таблица для хранения состояний пользователей
  // ключ - id пользователя, значение - данные состояния пользователя
  final Map<int, StateData> _states = {};

  // Устанавливаем состояние пользователя
  // userId - id пользователя
  // state - состояние бота в диалоге с пользователем
  // data - данные состояния пользователя
  void setState(int userId, BotState state, {Map<String, dynamic>? data}) {
    _states[userId] = StateData(state: state, data: data);
  }

  // Получаем состояние пользователя
  BotState? getState(int userId) {
    return _states[userId]?.state;
  }

  // Получаем данные состояния пользователя
  Map<String, dynamic>? getData(int userId) {
    return _states[userId]?.data;
  }

  // Обновляем данные состояния
  void updateData(int userId, Map<String, dynamic> newData) {
    final current = _states[userId];
    if (current != null) {
      final updatedData = {...current.data, ...newData};
      _states[userId] = StateData(state: current.state, data: updatedData);
    }
  }

  // Удаляем состояние пользователя
  void deleteState(int userId) {
    _states.remove(userId);
  }

  // Проверяем, есть ли активное состояние у пользователя
  bool hasState(int userId) {
    return _states.containsKey(userId) &&
        _states[userId]!.state != BotState.idle;
  }
}
