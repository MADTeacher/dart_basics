void main() {
  mainLoop:
  for (var i = 0; i < 3; i++) {
    // метка «mainLoop:»
    print('start main loop');
    for (var x = 0; x < 3; x++) {
      print('start second loop');
      for (var y = 0; y < 3; y++) {
        print('start external loop');
        if (y >= 1) {
          print('break external loop');
          break mainLoop;
        }
        print('end external loop');
      }
      print('end second loop');
    }
    print('end main loop');
  }
  print('end loops');
}
