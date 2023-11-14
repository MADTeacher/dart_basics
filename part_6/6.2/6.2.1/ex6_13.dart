Future<String> getBigData() async{
  throw Exception('Прервалось соединение!!!');
}

Future<void> makeRequestData() async {
  print('Запрос данных');
  try {
    print(await getBigData());
    print('Данные получены');
  } catch (e) {
    print('Что-то пошло не так: $e');
  }
}

void main() {
  print('Запуск main');
  makeRequestData();
  print('Завершение main');
}
