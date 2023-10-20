sealed class Money {
  late final int _val;

  Money(this._val);

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
    case (RUB(), RUB()):
      print(money.$1 + money.$2);
    case (USD(), USD()):
      print(money.$1 + money.$2);
    case (EUR(), EUR()):
      print(money.$1 + money.$2);
    case (RUB(), USD()):
      print(money.$2 + money.$1);
    case _:
      print('Разные валюты');
  }
}

void main() {
  addMoney((RUB.fromStr('200'), RUB.fromStr('100'))); // RUB(300.00)
  addMoney((USD.fromStr('200'), USD.fromStr('100'))); // USD(300.00)
  addMoney((EUR.fromStr('200'), EUR.fromStr('100'))); // EUR(300.00)
  addMoney((RUB.fromStr('2000'), USD.fromStr('10'))); // USD(30.00)
  addMoney((EUR.fromStr('200'), RUB.fromStr('100'))); // Разные валюты
}
