import 'dart:async';

class Coin{
  final int value;
  Coin(this.value);
}

class CoinAcceptor{
  final _addCoin = StreamController<Coin>();
  Stream<Coin> get dataStream => _addCoin.stream;

  void addCoin(Coin coin) => _addCoin.add(coin);
}

class CoffeMachine{
  int valueCoins = 0;

  CoffeMachine(Stream<Coin> stream){
    stream.listen((coin){
      valueCoins += coin.value;
      if(valueCoins >= 30){
        print('Готовим капучино!');
      }
      print('Общее кол-во монет: $valueCoins');
    });
  }
}

void main(List<String> arguments) {
  print('Запуск main');
  var coinAcceptor = CoinAcceptor();
  var coffeMachine = CoffeMachine(coinAcceptor.dataStream);
  coinAcceptor.addCoin(Coin(35));
  print('Завершение main');
}
