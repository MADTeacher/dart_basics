void main(List<String> arguments) {
  var myList = [1, 2, 3, 4, 5, 6, 7];
  final [a, ..., b] = myList;
  print('a: $a, b: $b'); // a: 1, b: 7

  final [c, d, ...] = myList;
  print('c: $c, d: $d'); // c: 1, d: 2

  final [..., e, f] = myList;
  print('e: $e, f: $f'); // e: 6, f: 7
}
