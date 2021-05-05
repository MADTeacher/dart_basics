void main(List<String> arguments) {
  var i = 13;
  while(i > 0){
    i--;
    if (i % 2 == 0){
      continue;
    }
    print(i); // 11  9  7  5  3  1
  }

  i = 33;
  while(true){
    if (i <= 3){
      break;
    }
    i--;
  }
  print(i); // 3
}