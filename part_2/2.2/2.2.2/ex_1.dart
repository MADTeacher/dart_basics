void main(List<String> arguments) {
  var myRecord1 = (10, '-_-');
  
  var (fist, second) = myRecord1;
  print('$fist  $second'); // 10  -_-

  var (a, _) = myRecord1;
  print('$a'); // 10

  var myRecord2 = (3.14, cost: 10, smile: '-_-', 22);
  var (fistPos, secondPos, cost: costPos, smile: SmilePos) = myRecord2;
  print('$fistPos,  $secondPos,  $costPos,  $SmilePos'); // 3.14  22  10  -_-

  var (b, _, cost: _, smile: c) = myRecord2;
  print('$b,  $c'); // 3.14  -_-
}
