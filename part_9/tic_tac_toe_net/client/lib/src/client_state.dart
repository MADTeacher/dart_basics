enum ClientState {
  idle, // состояние покоя
  nickName, // ввод имени
  mainMenu, // главное меню
  joinToRoom, // выбор комнаты
  getWinsList, // список матчей, закончившихся победой
  waitStartGame, // ожидание начала игры
  stepWaiting, // ожидание своего хода
  playing, // игра, в данном состоянии совершается ход
}