import 'dart:async';

final censored = '凸( •̀_•́ )凸';

Future<void> callPrint() async{
  await Future.delayed(
        Duration(milliseconds: 300),
        () {
          print('Hello Zone: ${Zone.current}');
          print('qwerty');
        },
      );
}

void main() async {
  await runZoned(
    () async {
      await callPrint();

      await runZoned(
        () async {
          await callPrint();
        },
        zoneSpecification: ZoneSpecification(print: (
          Zone self,
          ZoneDelegate parent,
          Zone zone,
          String line,
        ) {
          if (line.contains(Zone.current[#_secret] as String)) {
            line = censored;
          }
          parent.print(zone, '${DateTime.now()} $line');
        }),
      );
    },
    zoneValues: {#_secret: 'qwerty'}, // тип ключа - symbol
  );

  print(Zone.current[#_secret]);
}
