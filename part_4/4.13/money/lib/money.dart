abstract class IMoney {
  int get value;
  IMoney operator +(IMoney other);
  IMoney operator -(IMoney other);
}

class MoneyOperationError extends Error {}

class Rub implements IMoney {
  late final int _kopek;

  Rub._(this._kopek);
  Rub.kopek(int value) : this._(value);

  factory Rub(String rub) {
    var localRub = (double.parse(rub) * 100).toStringAsFixed(0);
    return Rub._(int.parse(localRub));
  }

  @override
  Rub operator +(IMoney other) {
    return Rub._(_kopek + other.value);
  }

  @override
  int get value => _kopek;

  @override
  String toString() {
    var rub = (_kopek / 100).toStringAsFixed(2);
    return 'Rub($rub)';
  }

  @override
  Rub operator -(IMoney other) {
    if (_kopek - other.value < 0) {
      throw MoneyOperationError();
    }
    return Rub._(_kopek - other.value);
  }
}
