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

class DigitalRub {
  final Rub _value;

  DigitalRub(this._value);

  DigitalRub operator +(DigitalRub other) {
    return DigitalRub(_value + other._value);
  }

  DigitalRub operator *(int multiplier) {
    if (multiplier < 0) {
      throw ArgumentError('Multiplier cannot be negative');
    }
    return DigitalRub(_value * multiplier);
  }

  @override
  String toString() {
    return _value.toString();
  }
}

void main() {
  var digitalRub = DigitalRub(Rub(10496));
  print(digitalRub);
  print(digitalRub * 2); // Rub(209), kopek(92)
  print(digitalRub + DigitalRub(Rub(345))); // Rub(108), kopek(41)
  // print(digitalRub * -2); // Error
}
