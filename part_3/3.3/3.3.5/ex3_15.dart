int sub(
  int a,
  int b, {
  int c = 10,
  int Function(int, int)? func,
}) {
  if (func == null) {
    return 0;
  }
  return c - func(a, b);
}

void main(List<String> arguments) {
  var a = 13, b = 12;
  print(sub(
    2,
    4,
    c: 2,
    func: a < b
        ? (int a, int b) {
            return a * b;
          }
        : (int a, int b) {
            return a - b;
          },
  )); 
}
