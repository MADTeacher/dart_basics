int Function(int) myClosure(
  int a,
  int b,
  int Function(int, int) func,
) {
  return (int value) => value - func(a, b);
}

void main(List<String> arguments) {
  var globalValue = 99;
  int mainFunc(int a, int b) {
    globalValue--;
    print('globalValue: $globalValue');
    return a < b ? 
          globalValue - a + b : 
          -globalValue + b * a;
  }

  var calculation = myClosure(3, 5, mainFunc);
  print(calculation(3)); // globalValue: 98, -97
  print(calculation(2)); // globalValue: 97, -97
  calculation = myClosure(6, -2, mainFunc);
  print(calculation(3)); // globalValue: 96, 111
  print(calculation(7)); // globalValue: 95, 114

  print('Final globalValue: $globalValue');
  // Final globalValue: 95
}
