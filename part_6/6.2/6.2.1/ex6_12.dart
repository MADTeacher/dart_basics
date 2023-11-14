String getBigData() {
  return 'Гигатонны информации))';
}

Future<void> makeRequestData() async {
  print('Запрос данных');
  var data = await getBigData();
  print(data);
  print('Данные получены');
}

void main(List<String> arguments) {
  print('Запуск main');
  makeRequestData();
  print('Завершение main');
}
