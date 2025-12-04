class Rub {
  late final int kopek;

  Rub._(this.kopek);

  factory Rub(String rub) {
    var localRub = (double.parse(rub) * 100).toStringAsFixed(0);
    return Rub._(int.parse(localRub));
  }

  // перегрузка сложения
  Rub operator +(Object other) {
    if (other is Rub) {
      return Rub._(kopek + other.kopek);
    } else if(other is int){
      return Rub._(kopek + other*100);
    }else if (other is double){
      var localRub = (other * 100).toStringAsFixed(0);
      return Rub._(kopek + int.parse(localRub));
    }else{
      print("(╯'□')╯︵ ┻━┻ WTF!!!");
      return Rub._(0);
    }
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
  print(rub1 + Rub('4.55')); // Rub(14.55)
  print(rub1 + 2); // Rub(12.00)
  print(rub1 + 5.5); // Rub(15.50)
  print(rub1 + "33"); // (╯'□')╯︵ ┻━┻ WTF!!! Rub(0.00)
}
