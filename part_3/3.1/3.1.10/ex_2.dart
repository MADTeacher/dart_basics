Iterable<int> myGenerator() sync* {
  yield 0;
  yield 1;
  yield 2;
  yield 3;
  yield 4;
}

void main(List<String> arguments) {
  var result = <int>[];
  for(var it in myGenerator()){
    result.add(it);
  }
  print(result); // [0, 1, 2, 3, 4]
}
