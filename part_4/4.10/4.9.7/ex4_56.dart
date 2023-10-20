class RUB {
  int _val;
  RUB._(this._val);

  factory RUB.fromStr(String value) {
    var rub = (double.parse(value) * 100).toStringAsFixed(0);
    return RUB._(int.parse(rub));
  }

  RUB.kopek(this._val);

  int get value => _val;

  @override
  String toString() {
    var rub = (value / 100).toStringAsFixed(2);
    return 'RUB($rub)';
  }
}

mixin Inflation on RUB {
  RUB inflation(int pecent) {
    return switch (pecent) {
      != 0 => RUB.kopek(value - (value * pecent / 100).ceil()),
      _ => RUB.kopek(value),
    };
  }
}

mixin YearPecent on RUB {
  int pecent = 14;

  RUB yearEnd() {
    return RUB.kopek(value + (value * pecent / 100).ceil());
  }
}

class PaperRUB extends RUB with Inflation {
  PaperRUB._(int value) : super.kopek(value);
  PaperRUB.kopek(int value) : super.kopek(value);
  PaperRUB.rub50() : this._(5000);
  PaperRUB.rub100() : this._(10000);
}

class BankBox extends RUB with YearPecent, Inflation {
  BankBox._(int value, int bankPecent) : super.kopek(value){
    pecent = bankPecent;
  }

  factory BankBox.fromStr(String value, int bankPecent) {
    var rub = (double.parse(value) * 100).toStringAsFixed(0);
    return BankBox._(int.parse(rub), bankPecent);
  }
}


void main() {
  var rub = PaperRUB.rub100();
  print(rub); // RUB(100.00)
  print(rub.inflation(-13)); // RUB(113.00)
  print(rub.inflation(13)); // RUB(87.00) 
  print(rub.inflation(0)); // RUB(100.00)

  var bankBox = BankBox.fromStr('1000000', 23);
  print(bankBox); // RUB(1000000.00)
  print(bankBox.yearEnd()); // RUB(1230000.00)
}
