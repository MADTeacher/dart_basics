enum DoorCommand {none, open, close, prepare}

void main(List<String> arguments) {
  var command = DoorCommand.open;
  switch (command) {
    prepare:
    case DoorCommand.prepare:
      print('prepare'); // 2 <- prepare
      break;
    case DoorCommand.close:
      print('closed');
      continue prepare;
    case DoorCommand.open:
      print('open'); // 1 <- open
      continue prepare;
    default:
      print('default');
  }
}
