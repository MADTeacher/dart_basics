mixin class Inflation{
  int pecent = 14;

  // Inflation(this.pecent); // error
  // The class 'Inflation' can't be used as a mixin 
  // because it declares a constructor.

  RUB inflation(RUB rub){
    return switch(pecent){
      != 0 => RUB.kopek(rub.value - (rub.value * pecent / 100).ceil(),),
      _ => RUB.kopek(rub.value),
    };
  }
}

class RUB with Inflation { // используется как миксин
// class RUB extends Inflation // используется как класс
  int _val;
  RUB._(this._val, [inflationPecent = 14]){
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

  @override
  String toString() {
    var rub = (value / 100).toStringAsFixed(2);
    return 'RUB($rub)';
  }
}

void main() {
  var infl = Inflation();
  RUB rub = RUB.fromStr('100', 55);
  print(rub.inflation(rub)); // RUB(45.00)
  print(infl.inflation(rub)); // RUB(86.00)
}
