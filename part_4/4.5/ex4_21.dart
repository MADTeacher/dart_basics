class Rub {
  late final int kopek;

  Rub._(this.kopek);

  factory Rub(String rub) {
    var localRub = (double.parse(rub) * 100).toStringAsFixed(0);
    return Rub._(int.parse(localRub));
  }

  @override
  int get hashCode => kopek.hashCode;
  // Переопределение hashCode необходимо для правильной
  // проверки равенства объектов

  // перегрузка проверки на равенство
  @override
  bool operator ==(Object other) {
    if (other is Rub) {
      return kopek == other.kopek;
    } else if (other is int) {
      return kopek == other * 100;
    } else if (other is double) {
      var localRub = (other * 100).toStringAsFixed(0);
      return kopek == int.parse(localRub);
    } else {
      print("(╯'□')╯︵ ┻━┻ WTF!!!");
      return false;
    }
  }

  bool operator >(Rub other) {
      return kopek > other.kopek;
  }

  bool operator <(Rub other) {
      return kopek < other.kopek;
  }

  bool operator >=(Rub other) {
      return kopek >= other.kopek;
  }

  bool operator <=(Rub other) {
      return kopek <= other.kopek;
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
  print(rub1 == Rub('10')); // true
  print(rub1 != Rub('10')); // false
  print(rub1 == 4); // false
  print(rub1 == 10.0); // true
  print(rub1 == '10.0'); // (╯'□')╯︵ ┻━┻ WTF!!!
  print(rub1 >= Rub('9')); // true
  print(rub1 <= Rub('15')); // true
  print(rub1 > Rub('10')); // false
  print(rub1 < Rub('11')); // false
}
