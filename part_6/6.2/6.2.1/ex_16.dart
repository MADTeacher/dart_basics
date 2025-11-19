void main() {
  print('Запуск main');
  Future.any<int>([
    Future.delayed(Duration(seconds: 3), () => 1),
    Future.delayed(Duration(seconds: 2), () => 2),
    Future.delayed(Duration(seconds: 1), () => 3),
  ]).then((value) {
    print(value);
  });
  print('Завершение main');
}
