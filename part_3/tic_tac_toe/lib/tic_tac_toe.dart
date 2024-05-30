import 'dart:io';

typedef Cell = int; // тип клетки поля
typedef GameState = int; // тип состояния игрового процесса

// фигуры в клетке поля
const Cell empty = 0;
const Cell cross = 1;
const Cell nought = 2;

// состояние игрового процесса
const GameState playing = 0;
const GameState draw = 1;
const GameState crossWin = 2;
const GameState noughtWin = 3;
const GameState quit = 3;

// Объявление глобальных переменных
late List<List<Cell>> board;
int boardSize = 3; // размер игрового поля по умолчанию
GameState state = playing;
Cell currentPlayer = cross; // текущий игрок

bool initBoard() {
  stdout.write('Enter the size of the board (3-9): ');
  int? size = int.tryParse(stdin.readLineSync()!);
  size ??= boardSize;
  if (size < 3 || size > 9) {
    return false;
  }
  boardSize = size;
  board = List.generate(
    size,
    (_) => List.filled(boardSize, empty),
  );
  return true;
}

void printBoard() {
  stdout.write('  ');
  for (int i = 0; i < boardSize; i++) {
    stdout.write('${i + 1} '); // вывод номера столбца
  }
  stdout.write('\n');

  for (int i = 0; i < boardSize; i++) {
    stdout.write('${i + 1} '); // вывод номера строки
    for (int j = 0; j < boardSize; j++) {
      switch (board[i][j]) {
        case empty:
          stdout.write('. ');
        case cross:
          stdout.write('X ');
        case nought:
          stdout.write('O ');
      }
    }
    print('');
  }
}

bool makeMove(int x, int y) {
  if (board[y][x] == empty) {
    board[y][x] = currentPlayer;
    return true;
  }
  return false;
}

bool checkWin(Cell player) {
  // проверка по строкам и столбцам
  for (int i = 0; i < boardSize; i++) {
    if (board[i].every((cell) => cell == player)) return true;
    if (board.every((row) => row[i] == player)) return true;
  }
  // проверка по главной диагонали
  if (List.generate(boardSize, (i) => board[i][i]).every(
    (cell) => cell == player,
  )) {
    return true;
  }
  // проверка по обратной диагонали
  if (List.generate(boardSize, (i) => board[i][boardSize - i - 1])
      .every((cell) => cell == player)) return true;
  return false;
}

bool checkDraw() {
  return board.every((row) => row.every(
        (cell) => cell != empty,
      ));
}

void switchPlayer() {
  currentPlayer = currentPlayer == cross ? nought : cross;
}

void updateState() {
  if (checkWin(cross)) {
    state = crossWin;
  } else if (checkWin(nought)) {
    state = noughtWin;
  } else if (checkDraw()) {
    state = draw;
  }
}

void play() {
  while (state == playing) {
    printBoard();
    StringBuffer buffer = StringBuffer();
    buffer.write(
      "${currentPlayer == cross ? 'X' : 'O'}'s turn.",
    );
    buffer.write(
      "Enter row and column (e.g. 1 2): ",
    );
    stdout.write(buffer.toString());

    bool validInput = false;
    int? x, y;

    while (!validInput) {
      String? input = stdin.readLineSync();
      if (input == null) {
        print("Invalid input. Please try again.");
        continue;
      }
      if (input == "q") {
        state = quit;
        break;
      }
      var inputList = input.split(' ');
      if (inputList.length != 2) {
        print("Invalid input. Please try again.");
        continue;
      }
      x = int.tryParse(inputList[1]);
      y = int.tryParse(inputList[0]);
      if (x == null || y == null) {
        print("Invalid input. Please try again.");
        continue;
      }
      if (x < 1 || x > boardSize || y < 1 || y > boardSize) {
        print("Invalid input. Please try again.");
        continue;
      }
      x -= 1;
      y -= 1;
      if (makeMove(x, y)) {
        updateState();
        switchPlayer();
        validInput = true;
      } else {
        stdout.writeln('This cell is already occupied!');
      }
    }
  }

  printBoard();
  switch (state) {
    case crossWin:
      stdout.writeln('X wins!');
    case noughtWin:
      stdout.writeln('O wins!');
    case draw:
      stdout.writeln("It's a draw!");
    default:
      break;
  }
}
