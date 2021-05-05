void iterableStream(List<int> list) async {
  var stream = Stream.fromIterable(list);
  print('Начало работы потока');
  await for (var num in stream) {
      print(num);
  }
  print('Завершение работы потока');
}

void main(List<String> arguments) {
  iterableStream([1, 5]);
}
