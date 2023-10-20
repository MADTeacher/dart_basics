class Rub {
  late final int kopek;

  Rub._(this.kopek);

  factory Rub(String rub) {
    var localRub = (double.parse(rub) * 100).toStringAsFixed(0);
    return Rub._(int.parse(localRub));
  }

  // перегрузка побитового И
  Rub operator &(Object other) {
    if (other is Rub) {
      return Rub._(kopek & other.kopek);
    } else if(other is int){
      return Rub._(kopek & other*100);
    }else if (other is double){
      var localRub = (other * 100).toStringAsFixed(0);
      return Rub._(kopek & int.parse(localRub));
    }else{
      print("(╯'□')╯︵ ┻━┻ WTF!!!");
      return Rub._(0);
    }
  }

  // перегрузка побитового ИЛИ
  Rub operator |(int other) {
    return Rub._(kopek | (other*100));
  }

  // перегрузка побитового исключающего ИЛИ
  Rub operator ^(int other) {
    return Rub._(kopek ^ (other*100));
  }

  // перегрузка побитового НЕ
  Rub operator ~() {
    return Rub._(~kopek);
  }

  // перегрузка сдвига влево
  Rub operator <<(int other) {
    return Rub._(kopek << other);
  }

  // перегрузка сдвига вправо
  Rub operator >>(int other) {
    return Rub._(kopek >> other);
  }

  // перегрузка беззнакового сдвига вправо
  Rub operator >>>(int other) {
    return Rub._(kopek >>> other);
  } 

  // переопределение
  @override
  String toString() {
    var rub = (kopek / 100).toStringAsFixed(2);
    return 'Rub($rub)';
  }
}

void main(List<String> arguments) {
  var rub1 = Rub('109');
  print(rub1 & 100); // Rub(87.20)
  print(rub1 & Rub('20')); // Rub(6.56)
  print(rub1 & 30.7); // Rub(27.08)
  print(rub1 & '30.7'); // (╯'□')╯︵ ┻━┻ WTF!!! Rub(0.00)
  print(rub1 | 100); // Rub(121.80)
  print(rub1 ^ 86); // Rub(28.28)
  print(~rub1); // Rub(-109.01)
  print(rub1 << 2); // Rub(436.00)
  print(rub1 >> 2); // Rub(27.25)
  print(rub1 >>> 1); // Rub(54.50)
}
