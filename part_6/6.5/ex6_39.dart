import 'dart:async';

void main() async {
  await runZonedGuarded(
    () async {
      Timer(Duration(milliseconds: 1), () {
        print('Запуск одноразового таймера');
      });
      Timer.periodic(Duration(milliseconds: 500), (timer) { 
        print('Запуск периодического таймера');
      });
    },
    (Object error, StackTrace stackTrace) {
      print('error: $error, stackTrace: $stackTrace');
    },
    zoneSpecification: ZoneSpecification(
      createTimer: (
        Zone self,
        ZoneDelegate parent,
        Zone zone,
        Duration duration,
        void Function() f,
      ) {
        var newDuration = duration + Duration(seconds: 2);
        return parent.createTimer(zone, newDuration, f);
      },
      createPeriodicTimer: (
        Zone self,
        ZoneDelegate parent,
        Zone zone,
        Duration period,
        void Function(Timer timer) f,
      ) {
        return parent.createPeriodicTimer(
          zone,
          period,
          (Timer timer) {
            if (timer.tick > 3) {
              timer.cancel();
              return;
            }
            print('Hello Zone: ${Zone.current}');
          },
        );
      },
    ),
  );
  print('Завершение программы');
}
