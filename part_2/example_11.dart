void main(List<String> arguments) {
  var command = 'close'; // проверяемое значение
  switch (command) {
    case 'close': // если значение в command == 'close'
      print('closed'); // <- closed
      break;
    case 'open': // если значение в command == 'open'
      print('open');
      break;
    default: // если не подошел ни один вариант
      print('default');
  }

  switch (command) {
    case 'close':
    case 'open':
      print('open/close'); // <- open/close
      break;
    default:
      print('default');
  }

  command = 'open';
  switch (command) {
    prepare:
    case 'prepare':
      print('prepare'); // 2 <- prepare
      break;
    case 'close':
      print('closed'); 
      continue prepare;
    case 'open':
      print('open'); // 1 <- open
      continue prepare;
    default:
      print('default');
  }

}
