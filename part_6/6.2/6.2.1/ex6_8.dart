import 'dart:async';
import 'dart:io';

void main(List<String> arguments) async {
  var count = 0;
  Timer.periodic(
    Duration(milliseconds: 500),
    (timer) {
      // вызов функции, запрос на бэк и т.д.
      stdout.write('*');
      count++;
      if (count >= 10) {
        timer.cancel();
      }
    },
  );
}
