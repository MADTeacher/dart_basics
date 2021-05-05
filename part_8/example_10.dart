String getBigData() {
  return 'Гигатонны информации))';
}

String changeData(String data) {
  return data.toUpperCase();
}

Future<void> makeRequestData() async {
  print('Запрос данных');
  var data = await getBigData();
  print(data);
  print('Данные получены');
  print('Приступаем к изменению данных');
  print(await changeData(data));
  print('Данные изменены');
}

void main(List<String> arguments) {
  print('Запуск main');
  makeRequestData();
  print('Завершение main');
}
