Iterable<int> myGenerator() sync* {
  var k = 0;
  while (k < 5) {
    yield k++;
  }
}

void main(List<String> arguments) {
  var result = <int>[];
  for(var it in myGenerator()){
    result.add(it);
  }
  print(result); // [0, 1, 2, 3, 4]
}
