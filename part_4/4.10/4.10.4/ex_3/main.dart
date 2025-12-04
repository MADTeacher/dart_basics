import 'lib_a.dart';

class Rub implements IMoney {
  late final int _kopek;

  Rub._(this._kopek);
  Rub.fromInt(int value) : this._(value);

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
  IMoney operator -(IMoney other) {
    // TODO: implement -
    throw UnimplementedError();
  }
}

class USD implements IMoney {
  late final int _cent;

  USD._(this._cent);
  USD.fromInt(int value) : this._(value);

  factory USD(String usd) {
    var localCent = (double.parse(usd) * 100).toStringAsFixed(0);
    return USD._(int.parse(localCent));
  }

  @override
  USD operator +(IMoney other) {
    if (other is USD) {
      return USD._(_cent + other.value);
    }
    return USD._(0);
  }

  @override
  int get value => _cent;

  @override
  String toString() {
    var usd = (_cent / 100).toStringAsFixed(2);
    return 'USD($usd)';
  }

  @override
  IMoney operator -(IMoney other) {
    // TODO: implement -
    throw UnimplementedError();
  }
}

class Wallet {
  var money = <IMoney>[];
  final int rub2usd;

  Wallet(this.rub2usd);

  void addMoney(IMoney money) {
    this.money.add(money);
  }

  void removeMoney(IMoney money) {
    this.money.removeWhere(
          (element) => element.value == money.value,
        );
  }

  Rub allConverToRub() {
    var rub = Rub('0');
    for (var it in money) {
      if (it is Rub) {
        rub += it;
      }else if (it is USD){
        rub += Rub.fromInt(it.value * rub2usd);
      }
    }
    return rub;
  }

  USD allConverToUsd() {
    var usd = USD('0');
    for (var it in money) {
      if (it is USD) {
        usd += it;
      }else if (it is Rub){
        usd += USD.fromInt((it.value / rub2usd).ceil());
      }
    }
    return usd;
  }

  @override
  String toString() {
    var rub = Rub('0');
    var usd = USD('0');
    for (var it in money) {
      if (it is Rub) {
        rub += it;
      } else if (it is USD) {
        usd += it;
      }
    }
    return 'Wallet($rub, $usd)';
  }

  Rub totalRub() {
    var rub = Rub('0');
    for (var it in money) {
      if (it is Rub) {
        rub += it;
      }
    }
    return rub;
  }

  USD totalUsd() {
    var usd = USD('0');
    for (var it in money) {
      if (it is USD) {
        usd += it;
      }
    }
    return usd;
  }
}

void main() {
  var wallet = Wallet(100);
  wallet.addMoney(Rub('1000'));
  wallet.addMoney(USD('100'));
  wallet.addMoney(Rub('43'));
  wallet.addMoney(USD('21'));

  print(wallet);

  print(wallet.allConverToRub());
  print(wallet.allConverToUsd());
}
