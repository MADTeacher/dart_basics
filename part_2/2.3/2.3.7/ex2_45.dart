void main(List<String> arguments) {
  var command = 'open';
  switch (command) {
    prepare:
    case 'prepare':
      print('prepare'); // 2 <- prepare
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
