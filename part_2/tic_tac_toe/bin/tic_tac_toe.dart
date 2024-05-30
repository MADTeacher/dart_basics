import 'dart:io';

// фигуры в клетке поля
const int empty = 0;
const int cross = 1;
const int nought = 2;

// состояние игрового процесса
const int playing = 0;
const int draw = 1;
const int crossWin = 2;
const int noughtWin = 3;
const int quit = 3;

void main() {
  late List<List<int>> board;
  int boardSize = 3; // размер игрового поля по умолчанию
  int state = playing;
  int currentPlayer = cross; // текущий игрок

  while (true) {
    stdout.write('Enter the size of the board (3-9): ');
    int? size = int.tryParse(stdin.readLineSync()!);
    size ??= boardSize;
    if (size < 3 || size > 9) {
      print('Invalid size, please enter again');
      continue;
    }
    boardSize = size;
    board = List.generate(
      size,
      (_) => List.filled(boardSize, empty),
    );
    break;
  }

  // Вывод в терминал состояния игрового поля
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
  // Завершение вывода в терминал

  while (state == playing) {
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
        // выход
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

      if (board[y][x] == empty) {
        board[y][x] = currentPlayer;
        // Поиск наличия выигрышной комбинации
        // Проверка по строкам и столбцам
        bool winFound = false;
        for (int i = 0; i < boardSize; i++) {
          if (board[i].every((cell) => cell == currentPlayer)) {
            winFound = true;
            break;
          }
          if (board.every((row) => row[i] == currentPlayer)) {
            winFound = true;
            break;
          }
        }
        // Проверка по главной диагонали
        if (!winFound) {
          if (List.generate(boardSize, (i) => board[i][i])
              .every((cell) => cell == currentPlayer)) {
            winFound = true;
          }
        }
        // Проверка по обратной диагонали
        if (!winFound) {
          if (List.generate(
            boardSize,
            (i) => board[i][boardSize - i - 1],
          ).every((cell) => cell == currentPlayer)) {
            winFound = true;
          }
        }
        // Определение победителя
        if (winFound) {
          state = currentPlayer == cross ? crossWin : noughtWin;
        } else if (board.every(
          (row) => row.every((cell) => cell != empty),
        )) {
          // Проверка на ничью
          state = draw;
        }

        // Вывод в терминал состояния игрового поля
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
        // Завершение вывода в терминал

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

        // Переключение игрока
        currentPlayer = currentPlayer == cross ? nought : cross;
        validInput = true;
      } else {
        stdout.writeln('This cell is already occupied!');
      }
    }
  }
}
