class Calc{
  static int add(int a, int b){
    return a + b;
  }

  int sum(int a, int b) => add(a, b);
}

void main(List<String> arguments) {
  print(Calc.add(3, 5)); // 8
  print(Calc.add(13, 5)); // 18
  var calc = Calc();
  print(calc.sum(13, 5)); // 18
}
