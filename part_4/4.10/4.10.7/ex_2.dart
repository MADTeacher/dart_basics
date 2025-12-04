mixin Inflation {
  int pecent = 14;

  RUB inflation([RUB? rub]);
}

class RUB with Inflation {
  int _val;
  RUB._(this._val, [inflationPecent = 14]) {
    pecent = inflationPecent;
  }

  factory RUB.fromStr(String value, [inflationPecent = 14]) {
    var rub = (double.parse(value) * 100).toStringAsFixed(0);
    return RUB._(int.parse(rub), inflationPecent);
  }

  RUB.kopek(this._val, [inflationPecent = 14]) {
    pecent = inflationPecent;
  }

  int get value => _val;

  RUB operator +(RUB other) {
    return RUB._(value + other.value);
  }

  @override
  String toString() {
    var rub = (value / 100).toStringAsFixed(2);
    return 'RUB($rub)';
  }

  @override
  RUB inflation([RUB? rub]) {
    if (rub == null) {
      return switch (pecent) {
        != 0 => RUB.kopek(value - (value * pecent / 100).ceil()),
        _ => RUB.kopek(value),
      };
    }else{
      return switch (pecent) {
        != 0 => RUB.kopek(rub.value - (rub.value * pecent / 100).ceil()),
        _ => RUB.kopek(rub.value),
      };
    }
  }
}

void main() {
  var rub = RUB.fromStr('100', 55);
  print(rub.inflation()); // RUB(45.00)
  print(rub.inflation(RUB.fromStr('200'))); // RUB(90.00)
}
