import 'dart:async';

final censored = '凸( •̀_•́ )凸';

void main() async {
  await runZonedGuarded(
    () async {
      Future.error(censored);
      // или
      // Future.delayed(Duration(milliseconds: 300), () {
      //   throw ArgumentError(censored);
      // });
    },
    (Object error, StackTrace stackTrace) {
      print('error: $error, stackTrace: $stackTrace');
    }
  );
  print('Завершение программы');
}
