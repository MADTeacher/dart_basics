void main(List<String> arguments) {
  var fisrt = 10;
  var second = 20;
  (fisrt, second) = (second, fisrt);
  print('fisrt: $fisrt, second: $second'); // fisrt: 20, second: 10
}
