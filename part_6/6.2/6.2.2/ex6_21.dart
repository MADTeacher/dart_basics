void iterableStream(List<int> list) {
  var stream = Stream.fromIterable(list);
  print('Начало работы потока');
  stream.listen(
    (s) => print(s),
  );
  print('Завершение работы потока');
}

void main(List<String> arguments) {
  iterableStream([1, 2, 3, 4, 5]);
}
