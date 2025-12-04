part of 'money.dart';

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