import 'src/my_calculator.dart' deferred as calculator;

void main(List<String> arguments) {
  callLibrary(34, 5);
}

Future callLibrary(double a, double b) async{
  await calculator.loadLibrary();
  print(calculator.div(a, b)); // 6.8
  print(calculator.bb);
}
