void main(List<String> arguments) {
  var myList = [1, 2];
  final [a, _] = myList;
  print('a: $a'); // a: 1

  myList = [1, 2, 3, 4];
  final [b, _, c, _] = myList;
  print('b: $b, c: $c'); // b: 1, c: 3
}
