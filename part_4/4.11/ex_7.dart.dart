class Rub {
  final int kopek;
  Rub(this.kopek);

  (int rub, int kop) get rubWithKop {
    return (kopek ~/ 100, kopek % 100);
  }

  // перегрузка сложения
  Rub operator +(Rub other) {
    return Rub(kopek + other.kopek);
  }

  // перегрузка вычитания
  Rub operator -(Rub other) {
    var temp = 0;
    if (kopek - other.kopek >= 0) {
      temp = kopek - other.kopek;
    } else {
      print("(╯'□')╯︵ ┻━┻ Банкрот!!!");
    }
    return Rub(temp);
  }

  // перегрузка умножения
  Rub operator *(int value) {
    return Rub(kopek * value);
  }

  // перегрузка деления
  Rub operator /(int value) {
    // осуществляем целочисленное деление
    return Rub(kopek ~/ value);
  }

  // переопределение
  @override
  String toString() {
    var (rub, kop) = rubWithKop;
    return 'Rub($rub), kopek($kop)';
  }
}

extension type DigitalRub(Rub value) implements Rub {
  DigitalRub operator +(DigitalRub other) {
    return DigitalRub(value + other.value);
  }

  DigitalRub operator *(int multiplier) {
    if (multiplier < 0) {
      throw ArgumentError('Multiplier cannot be negative');
    }
    return DigitalRub(value * multiplier);
  }
}

void main() {
  var digitalRub1 = DigitalRub(Rub(10496));
  var digitalRub2 = DigitalRub(Rub(7696));
  print(digitalRub1.rubWithKop);
  print(digitalRub1 - digitalRub2);

  var rub = digitalRub1 - Rub(345);
  print('${rub.runtimeType}, $rub');

  // var rub2 = digitalRub1 + Rub(345); // Error
  // print(digitalRub1 * -2); // Error
}
