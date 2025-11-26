import 'package:common/message.dart';

import '../client.dart';
import 'server_message_handlers.dart';

// Функция для переадресации сообщений от сервера 
// на соответствующие обработчики
void messageHandler(
  ServerMessage message,
  TicTacToeClient client,
) {
  final handlers = ServerMessageHandlers(client);
  
  switch (message) {
    // Обрабатываем ответ на запрос о присоединении к комнате
    case JoinToRoomSM():
      handlers.handleRoomJoinResponse(message);
    // Обрабатываем сообщение об инициализации игры
    case InitiateGameSM():
      handlers.handleInitGame(message);
    // Обрабатываем сообщение об обновлении состояния игры
    case UpdateStateSM():
      handlers.handleUpdateState(message);
    // Обрабатываем сообщение об окончании игры
    case EndGameSM():
      handlers.handleEndGame(message);
    // Обрабатываем сообщение об ошибке
    case ErrorSM():
      handlers.handleError(message);
    // Обрабатываем сообщение о списке комнат
    case RoomsInfoSM():
      handlers.handleRoomListResponse(message);
    // Обрабатываем сообщение о подтверждении никнейма
    case NickNamePlayerSM():
      handlers.handleNickNameResponse(message);
    // Обрабатываем сообщение об отключении оппонента
    case OpponentLeftSM():
      handlers.handleOpponentLeft(message);
    // Обрабатываем сообщение о списке завершенных игр
    case WinnersListSM():
      handlers.handleFinishedGamesResponse(message);
    // Обрабатываем сообщение с данными по запрошенной завершенной игре
    case WinnerInfoSM():
      handlers.handleFinishedGameResponse(message);
    default:
      // Если пришло неизвестное сообщение
      print(
        'Received unhandled message type \'${message.mType}\' from server.',
      );
  }
}
