interface class Money {
  late final int _val;

  Money._(this._val);

  Money.fromInt(int value) : this._(value);

  Money.fromString(String value)
      : this._(
          (double.parse(value) * 100).toInt(),
        );

  double value() {
    return _val / 100;
  }

  Money operator +(Money other) {
    return Money._(_val + other._val);
  }

  Money operator -(Money other) {
    var temp = 0;
    if (_val - other._val >= 0) {
      temp = _val - other._val;
    } else {
      print("(╯'□')╯︵ ┻━┻ Банкрот!!!");
    }
    return Money._(temp);
  }

  @override
  String toString() {
    var money = (_val / 100).toStringAsFixed(2);
    return 'Money($money)';
  }
}

class Rub extends Money {
  Rub(String value) : super.fromString(value);

  @override
  Money operator +(Money other) {
    return Money._(_val + other._val);
  }
}

