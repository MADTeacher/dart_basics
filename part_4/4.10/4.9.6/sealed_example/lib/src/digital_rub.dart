part of 'money.dart';

class DigitalRUB extends RUB {
  DigitalRUB._(super.val);

  factory DigitalRUB.fromStr(String value) {
    var rub = (double.parse(value) * 100).toStringAsFixed(0);
    return DigitalRUB._(int.parse(rub));
  }

  @override
  DigitalRUB operator +(Money other) {
    return DigitalRUB._(value + other.value);
  }

  @override
  String toString() {
    var rub = (value / 100).toStringAsFixed(2);
    return 'DigitalRUB($rub)';
  }
}