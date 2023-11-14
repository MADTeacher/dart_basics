void main() {
  var myList = [
    (10, '-_-'),
    ('^_^', 10, 20),
    (5, smile: 'O_O'),
    (5, smile: '-_-'),
    (4, smile: '-_-', pruff: [23, 45]),
    (4, pruff: [23, 45, 50]),
  ];

  for (var element in myList) {
    switch (element) {
      case (10, '-_-') ||
            (4, smile: '-_-', pruff: [23, 45]):
        print('Full match: $element');
      case (5, smile: String smile):
        print('Partial match with smile: $smile');
      case (_, pruff: List<int> pruff):
        print('Partial match with pruff: $pruff');
      default:
        print('No match: $element');
    }
  }
}
