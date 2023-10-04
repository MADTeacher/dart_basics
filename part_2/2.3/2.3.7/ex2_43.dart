void main(List<String> arguments) {
  var command = 'close'; // проверяемое значение
  switch (command) {
    case 'close': // если значение в command == 'close'
      print('closed'); // <- closed
    case 'open': // если значение в command == 'open'
      print('open');
    default: // если не подошел ни один вариант
      print('default');
  }
}
