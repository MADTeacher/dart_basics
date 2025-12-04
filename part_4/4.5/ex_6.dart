class Adder {
  int call(int a, int b) => a + b;
}

class ConstAdder {
  final int a;
  ConstAdder(this.a);

  int call(int b) => a + b;
}

void main(){
  final adder = Adder();
  final constAdder = ConstAdder(10);
  print(adder(10, 5)); // 15
  print(constAdder(5)); // 15
}
