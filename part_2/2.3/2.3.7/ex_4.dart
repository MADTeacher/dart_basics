void main() {
  var command = 'Oo';
  switch (command) {
    prepare:
    case 'prepare':
      print('prepare');
    case 'close':
      print('closed');
      continue prepare;
    case 'open':
      print('open');
      continue prepare;
    default: // или case _:
      print('default'); // <- default
  }
}
