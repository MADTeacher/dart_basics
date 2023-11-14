Stream<int> myGenerator(int last) async* {
  for (var i = 0; i <= last; i++) {
    yield i; 
  }
}

void createGenerator(int lastValue) async {
  var stream = myGenerator(lastValue);
  // слушаем поток и выводим получаемые данные в терминал
  stream.listen((s) => print(s)); 
}

void main(List<String> arguments) {
  print('Запуск main');
  createGenerator(20);
  print('Завершение main');
}
