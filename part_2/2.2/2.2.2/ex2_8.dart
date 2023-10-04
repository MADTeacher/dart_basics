void main(List<String> arguments) {
  var myRecord2 = (3.14, cost: 10, smile: '-_-', 22);
  var (b, c) = (myRecord2.$1, myRecord2.smile);
  print('$b,  $c'); // 3.14  -_-
}
