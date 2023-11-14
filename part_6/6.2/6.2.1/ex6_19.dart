import 'dart:async';

void main(List<String> arguments) {
  var future1 = Future.delayed(
    Duration(seconds: 2),
    () => 'Future 1',
  );
  var future2 = Future.delayed(
    Duration(seconds: 4),
    () => 'Future 2',
  );

  future1
      .timeout(
        Duration(seconds: 3),
        onTimeout: () => 'Timeout for Future 1',
      )
      .then((value) => print(value));

  future2
      .timeout(
        Duration(seconds: 3),
        onTimeout: () => 'Timeout for Future 2',
      )
      .then((value) => print(value));

  future2
      .timeout(
        Duration(seconds: 3),
      )
      .then((value) => print(value))
      .catchError(
        (e) => print(e),
      );
}
