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

extension type DigitalRub(Rub value) {
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
  var rub = Rub(10496);
  print(rub); // Rub(104), kopek(96)
  print(rub * -2); // Rub(-209), kopek(8)
  
  var digitalRub = DigitalRub(rub);
  print(digitalRub); // Rub(104), kopek(96)
  print(digitalRub * 2); // Rub(209), kopek(92)
  // Invalid argument(s): Multiplier cannot be negative
  // print(dugitalRub * -2); 
}
