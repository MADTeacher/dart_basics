enum ClientState {
  // ожидание подтверждения никнейма от сервера
  waitNickNameConfirm,
  // главное меню
  mainMenu,
  // ход игрока
  playerMove,
  // ход оппонента
  opponentMove,
  // конец игры
  endGame,
  // ожидание присоединения оппонента
  waitingOpponentInRoom,
  // ожидание ответа от сервера
  waitResponseFromServer,
}