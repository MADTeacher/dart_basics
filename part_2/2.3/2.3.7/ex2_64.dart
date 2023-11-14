void main() {
    var myList = [
    'Мама мыла раму',
    'Привет!',
    'Как дела?',
    'Синхрофазатрон',
    [1, 2, 3, 4, 5],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  ];

  for (var element in myList) {
    switch (element) {
      case String(length: > 10):
        print('Строка > 10 символов: $element');
      case List(length: <= 10):
        print('Список длиной <= 10 : $element');
      case _:
        print('Элемент с не нужной длинной: $element');
    }
  }
}

