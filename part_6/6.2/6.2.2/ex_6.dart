import 'dart:async';

class CoinAcceptor{
  final _addCoin = StreamController<int>();
  Stream<int> get dataStream => _addCoin.stream;

  void addCoin(int coin) => _addCoin.add(coin);
}

class CoffeMachine{
  int valueCoins = 0;

  CoffeMachine(Stream<int> stream){
    stream.listen(addCoin);
  }

  void addCoin(int coin){
    valueCoins += coin;
    if(valueCoins >=30){
      print('Готовим капучино!');
    }
    print('Общее кол-во монет: $valueCoins');
  }
}

void main(List<String> arguments) {
  print('Запуск main');
  var coinAcceptor = CoinAcceptor();
  final coffeMachine = CoffeMachine(coinAcceptor.dataStream);
  coinAcceptor.addCoin(25);
  coinAcceptor.addCoin(4);
  coinAcceptor.addCoin(3);
  print('Завершение main');
}
