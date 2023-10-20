class Rub {
  late final int kopek;

  Rub._(this.kopek);

  factory Rub(String rub) {
    var localRub = (double.parse(rub) * 100).toStringAsFixed(0);
    return Rub._(int.parse(localRub));
  }

  // перегрузка сложения
  Rub operator +(Rub other) {
    return Rub._(kopek + other.kopek);
  }

  // перегрузка вычитания
  Rub operator -(Rub other) {
    var temp = 0;
    if (kopek - other.kopek >= 0) {
      temp = kopek - other.kopek;
    } else{
      print("(╯'□')╯︵ ┻━┻ Банкрот!!!");
    }
    return Rub._(temp);
  }

  // перегрузка умножения
  Rub operator *(int value) {
    return Rub._(kopek * value);
  }

  // перегрузка деления
  Rub operator /(int value) {
    // осуществляем целочисленное деление
    return Rub._(kopek ~/ value);
  }

  // перегрузка остатка от деления
  Rub operator %(int value) {
    return Rub._(kopek % (value*100));
  }

  // перегрузка унарного минуса
  Rub operator -() {
    print("(╯'□')╯︵ ┻━┻ Банкрот!!!");
    return Rub._(-kopek);
  }

  // переопределение
  @override
  String toString() {
    var rub = (kopek / 100).toStringAsFixed(2);
    return 'Rub($rub)';
  }
}

void main(List<String> arguments) {
  var rub1 = Rub('10');
  var rub2 = -Rub('10'); // (╯'□')╯︵ ┻━┻ Банкрот!!!
  var rub3 = rub1 + rub2;
  print(rub3); // Rub(0.00)
  print(rub1 + Rub('4.55')); // Rub(14.55)
  print(rub3 - Rub('2')); // (╯'□')╯︵ ┻━┻ Банкрот!!! Rub(0.00)
  print(rub1 * 3); // Rub(30.00)
  print(rub1 / 2); // Rub(5.00)
  print(rub1 % 4); // Rub(2.00)
}
