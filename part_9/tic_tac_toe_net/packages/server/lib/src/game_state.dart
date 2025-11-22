enum GameState {
  draw,
  crossWin,
  noughtWin,
  crossStep,
  noughtStep,
  waitingOpponent,
  quit,
}

enum GameMode {
  playerVsPlayer('PvP'),
  playerVsComputer('PvC');

  const GameMode(this.modeStr);

  final String modeStr;
}