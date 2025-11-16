int? calculate([int? a]) {
  if (a == null) {
    return a;
  }
  return a * 7;
}

void main() {
  var c = calculate() ?? calculate(10);
  print(c); // 70

  var d = calculate(3) ?? calculate(10);
  print(d); // 21
}
