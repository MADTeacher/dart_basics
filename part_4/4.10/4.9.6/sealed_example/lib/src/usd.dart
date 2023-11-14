part of 'money.dart';

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