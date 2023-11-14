void main() {
  var command = 'close';
  switch (command) {
    case 'close':
    case 'open':
      print('open/close'); // <- open/close
    default:
      print('default');
  }
}
