void main() {
  var myList = [1, 4, 5, 2, 33, 45, 90];

  for (var element in myList) {
    switch (element) {
      case 2 || 3 || 5:
        print('a ($element) is 2, 3, or 5');
      case >= 30 && <= 40:
        print('a ($element) is between 30 and 40');
      default:
        print('Default value: $element');
    }
  }

  print('-----------------');
  myList = [1, 4, 5, 2, 33, 45, 90];
  var newList = <int>[];

  for (var element in myList) {
    newList.add(switch (element) {
      2 || 3 || 5 => element + 1,
      >= 30 && <= 40 => element * 2,
      < 50 => element - 5,
      == 1 => element + 3,
      _ => element,
    });
  }

  print(newList); // [-4, -1, 6, 3, 66, 40, 90]
}
