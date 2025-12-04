void main() {
  var myList = [
    (10, '-_-'),
    ('^_^', 10, 20),
    (5, smile: 'O_O'),
    (5, smile: '-_-'),
    (4, smile: '-_-', pruff: [23, 45]),
  ];

  for (var element in myList) {
    switch (element) {
      case (10, '-_-') ||
            (4, smile: '-_-', pruff: [23, 45]) ||
            (_, smile: _):
        print('Full match: $element');
      default:
        print('No match: $element');
    }
  }
}
