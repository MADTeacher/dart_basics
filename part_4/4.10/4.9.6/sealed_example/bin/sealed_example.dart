import 'package:sealed_example/sealed_example.dart';

void addMoney((Money, Money) money) {
  switch (money) {
    case (RUB(value: > 30000), RUB(value: <= 500)):
      print(money.$1 + money.$2);
    case (USD(), USD(value: <= 300)):
      print(money.$1 + money.$2);
    case (EUR(value: > 20000), EUR()):
      print(money.$1 + money.$2);
    case (RUB(value: > 50000), USD()):
      print(money.$2 + money.$1);
    case _:
      print('╭∩╮( •̀_•́ )╭∩╮');
  }
}

void wtfIsMoney(Money money) {
  switch (money) {
    case DigitalRUB():
      print('Цифровой рубль - $money');
    case PaperRUB():
      print('Бумажный рубль - $money');
    case USD():
      print('Доллар - $money');
    case EUR():
      print('Евро - $money');
  }
}

void rubWorker(RUB rub) {
  switch (rub) {
    case DigitalRUB(value: > 300000):
      print('Цифровой рубль - $rub');
    case PaperRUB(value: == 50000):
      print('Бумажный рубль - $rub');
    case _:
      print('Это не правильные рубли ╭∩╮( •̀_•́ )╭∩╮');
  }
}

void main(List<String> arguments) {
  rubWorker(RUB.create('1000', false));
  rubWorker(RUB.create('5000'));
  rubWorker(PaperRUB.rub500());
  rubWorker(PaperRUB.rub5000());
}

// void main(List<String> arguments) {
//   wtfIsMoney(RUB.create('98'));
//   wtfIsMoney(USD.fromStr('3'));
//   wtfIsMoney(EUR.fromStr('100'));
//   wtfIsMoney(DigitalRUB.fromStr('1000'));
//   wtfIsMoney(PaperRUB.rub50());
// }

// void main(List<String> arguments) {
//   addMoney((Money.fromStr('rub', '200'), Money.fromStr('rub', '100')));
//   addMoney((Money.fromStr('usd', '200'), Money.fromStr('usd', '3')));
//   addMoney((Money.fromStr('eur', '200'), Money.fromStr('eur', '100')));
//   addMoney((Money.fromStr('rub', '2000'), Money.fromStr('usd', '10')));
//   addMoney((Money.fromStr('eur', '200'), Money.fromStr('rub', '100')));
// }
