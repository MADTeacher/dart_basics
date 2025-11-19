import 'dart:async';

class Coin{
  final int value;
  Coin(this.value);
}

class CoinAcceptor{
  final _addCoin = StreamController<Coin>();
  Stream<Coin> get dataStream => _addCoin.stream;

  Future<void> addCoin(Coin coin) async{
    if (!_addCoin.isClosed){
      _addCoin.add(coin);
    }
  }
  Future<void> dispose() async => await _addCoin.close();
}

class CoffeMachine{
  int valueCoins = 0;

  CoffeMachine(CoinAcceptor coinAcceptor){
    coinAcceptor.dataStream.listen((coin) async{
      valueCoins += coin.value;
      if(valueCoins >= 30){
        print('Готовим капучино!');
      }
      if (valueCoins >= 60){
        await coinAcceptor.dispose();
      }
      print('Общее кол-во монет: $valueCoins');
    }, onDone: (){
      print('Завершение работы');
    });
  }
}

void main(List<String> arguments) async{
  print('Запуск main');
  var coinAcceptor = CoinAcceptor();
  var coffeMachine = CoffeMachine(coinAcceptor);
  await coinAcceptor.addCoin(Coin(35));
  await coinAcceptor.addCoin(Coin(5));
  await coinAcceptor.addCoin(Coin(20));
  await coinAcceptor.addCoin(Coin(63));
  print('Завершение main');
}
