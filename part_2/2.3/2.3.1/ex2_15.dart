void main(List<String> arguments) {
  var a = 10;
  var b = 30;
  var c = 7;
  if (a > b) {
    print('a > b');
  } else if (a > c){
    print('a > c'); // a > c
  }
  else{
    print('Ни то и ни другое');
  }
}
