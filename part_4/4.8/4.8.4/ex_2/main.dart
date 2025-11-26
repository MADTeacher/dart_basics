import 'lib_a.dart';

class Rub implements IMoney {
  late final int _kopek;

  Rub._(this._kopek);

  factory Rub(String rub) {
    var localRub = (double.parse(rub) * 100).toStringAsFixed(0);
    return Rub._(int.parse(localRub));
  }

  @override
  IMoney operator +(IMoney other) {
    if (other is Rub) {
      return Rub._(_kopek + other.value);
    }
    return Rub._(0);
  }

  @override
  IMoney operator -(IMoney other) {
    if (other is Rub) {
      var temp = 0;
      if (_kopek - other.value >= 0) {
        temp = _kopek - other.value;
      } else {
        print("(╯'□')╯︵ ┻━┻ Банкрот!!!");
      }
      return Rub._(temp);
    }
    return Rub._(0);
  }

  @override
  int get value => _kopek;

  @override
  String toString() {
    var rub = (_kopek / 100).toStringAsFixed(2);
    return 'Rub($rub)';
  }
}

void main() {
  var money = IMoney();
  print(money); // Money(0.00)

  IMoney rub = Rub('100');
  print(rub - Rub('4.6')); // Rub(95.40)
  print(rub + IMoney()); // Rub(0.00)
}
