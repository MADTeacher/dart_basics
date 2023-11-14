part 'eur.dart';
part 'usd.dart';
part 'rub.dart';
part 'paper_rub.dart';
part 'digital_rub.dart';


sealed class Money {
  late final int _val;

  Money(this._val);
  factory Money.fromStr(String currency, String value) {
    var money = (double.parse(value) * 100).toStringAsFixed(0);
    switch (currency.toLowerCase()) {
      case 'rub':
        return RUB.create(value);
      case 'usd':
        return USD(int.parse(money));
      case 'eur':
        return EUR(int.parse(money));
    }
    throw UnsupportedError('Неподдерживаемая валюта');
  }

  int get value => _val;
  Money operator +(Money other);
}