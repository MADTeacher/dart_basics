/// Состояния бота для диалогов
enum BotState {
  idle,
  waitingGroupName,
  waitingDisciplineName,
  waitingStudentName,
}

/// Данные состояния пользователя
class StateData {
  final BotState state;
  final Map<String, dynamic> data;

  StateData({required this.state, Map<String, dynamic>? data})
    : data = data ?? {};
}

/// Управление состояниями диалогов (in-memory)
class ConversationStateManager {
  final Map<int, StateData> _states = {};

  /// Установить состояние пользователя
  void setState(int userId, BotState state, {Map<String, dynamic>? data}) {
    _states[userId] = StateData(state: state, data: data);
  }

  /// Получить состояние пользователя
  BotState? getState(int userId) {
    return _states[userId]?.state;
  }

  /// Получить данные состояния пользователя
  Map<String, dynamic>? getData(int userId) {
    return _states[userId]?.data;
  }

  /// Обновить данные состояния
  void updateData(int userId, Map<String, dynamic> newData) {
    final current = _states[userId];
    if (current != null) {
      final updatedData = {...current.data, ...newData};
      _states[userId] = StateData(state: current.state, data: updatedData);
    }
  }

  /// Удалить состояние пользователя
  void deleteState(int userId) {
    _states.remove(userId);
  }

  /// Проверить, есть ли активное состояние у пользователя
  bool hasState(int userId) {
    return _states.containsKey(userId) &&
        _states[userId]!.state != BotState.idle;
  }
}
