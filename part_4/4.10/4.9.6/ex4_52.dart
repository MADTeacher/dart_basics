sealed class Money {
  late final int _val;

  Money(this._val);
  factory Money.fromStr(String currency, String value) {
    var money = (double.parse(value) * 100).toStringAsFixed(0);
    switch (currency.toLowerCase()) {
      case 'rub':
        return RUB(int.parse(money));
      case 'usd':
        return USD(int.parse(money));
      case 'eur':
        return EUR(int.parse(money));
    }
    ;
    throw UnsupportedError('Неподдерживаемая валюта');
  }

  int get value => _val;
  Money operator +(Money other);
}

class RUB extends Money {
  RUB(super.val);

  factory RUB.fromStr(String value) {
    var rub = (double.parse(value) * 100).toStringAsFixed(0);
    return RUB(int.parse(rub));
  }

  @override
  RUB operator +(Money other) {
    return RUB(value + other.value);
  }

  @override
  String toString() {
    var rub = (value / 100).toStringAsFixed(2);
    return 'RUB($rub)';
  }
}

class USD extends Money {
  USD(super.val);

  factory USD.fromStr(String value) {
    var usd = (double.parse(value) * 100).toStringAsFixed(0);
    return USD(int.parse(usd));
  }

  @override
  USD operator +(Money other) {
    if (other is RUB) {
      return USD(value + other.value ~/ 100);
    } else {
      return USD(value + other.value);
    }
  }

  @override
  String toString() {
    var usd = (value / 100).toStringAsFixed(2);
    return 'USD($usd)';
  }
}

class EUR extends Money {
  EUR(super.val);

  factory EUR.fromStr(String value) {
    var eur = (double.parse(value) * 100).toStringAsFixed(0);
    return EUR(int.parse(eur));
  }

  @override
  EUR operator +(Money other) {
    return EUR(value + other.value);
  }

  @override
  String toString() {
    var eur = (value / 100).toStringAsFixed(2);
    return 'EUR($eur)';
  }
}

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

void main() {
  addMoney((
    Money.fromStr('rub', '200'),
    Money.fromStr('rub', '100'),
  ));
  addMoney((
    Money.fromStr('usd', '200'),
    Money.fromStr('usd', '3'),
  ));
  addMoney((
    Money.fromStr('eur', '200'),
    Money.fromStr('eur', '100'),
  ));
  addMoney((
    Money.fromStr('rub', '2000'),
    Money.fromStr('usd', '10'),
  ));
  addMoney((
    Money.fromStr('eur', '200'),
    Money.fromStr('rub', '100'),
  ));
}
