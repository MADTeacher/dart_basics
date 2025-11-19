part of 'money.dart';

sealed class RUB extends Money {
  RUB(super.val);

  factory RUB.create(String value, [bool isDigital = true]) {
    var rub = (double.parse(value) * 100).toStringAsFixed(0);
    return switch (isDigital) {
      true => DigitalRUB._(int.parse(rub)),
      false => switch(value){
        '50' => PaperRUB.rub50(),
        '100' => PaperRUB.rub100(),
        '500' => PaperRUB.rub500(),
        '1000' => PaperRUB.rub1000(),
        '5000' => PaperRUB.rub5000(),
        _ => DigitalRUB._(int.parse(rub))
      },
    };
  }

  @override
  String toString() {
    var rub = (value / 100).toStringAsFixed(2);
    return 'RUB($rub)';
  }
}