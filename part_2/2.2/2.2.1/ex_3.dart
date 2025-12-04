void main(List<String> arguments) {
  var myList = [1, 2, 3, 4, 5, 6, 7];
  final [a, ...b, c] = myList;
  print('a: $a, b: $b, c: $c'); // a: 1, b: [2, 3, 4, 5, 6], c: 7

  final [d, e, ...f] = myList;
  print('d: $d, e: $e, f: $f'); // d: 1, e: 2, f: [3, 4, 5, 6, 7]

  final [...g, h, i] = myList;
  print('g: $g, h: $h, i: $i'); // g: [1, 2, 3, 4, 5], h: 6, i: 7
}
