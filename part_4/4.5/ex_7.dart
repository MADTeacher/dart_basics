class Adder {
  int call(int a, int b) => a + b;
}

class ConstAdder {
  final int a;
  ConstAdder(this.a);

  int call(int b) => a + b;
}

class Calculator {
  final int Function(int a, int b) adder;
  final int Function(int b) constAdder;
  Calculator(this.adder, this.constAdder);

  int sum(int a, int b) => adder(a, b);
  int constSum(int b) => constAdder(b);
}

void main(){
  final adder = Adder();
  final constAdder = ConstAdder(10);
  final calculator = Calculator(adder, constAdder.call);
  final calculator2 = Calculator(constAdder, adder);
  print(calculator.sum(10, 5)); // 15
  print(calculator.constSum(5)); // 15
}
