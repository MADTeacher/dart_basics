void main() {
  var myList = [
    'Мама мыла раму',
    'Привет!',
    'Привет! Как дела?',
    'Синхрофазатрон',
    [1, 2, 3, 4, 5],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
    (10, 20),
    (30, 15),
  ];

  for (var element in myList) {
    switch (element) {
      case String str
          when (str.contains('мы') && str.length > 10) || 
          str.startsWith('При'):
        print('String : $element');
      case List<int> list
          when list.reduce((value, element) => value + element) > 55:
        print('List : $element');
      case (int first, int second) when first > second:
        print('Record : $element');
    }
  }
}
