int add(int a, int b) => a + b;

int sub(
  int c,
  int a,
  int b,
  int Function(int, int) func,
) =>
    c - func(a, b);

void main(List<String> arguments) {
  print(sub(30, 21, 2, add)); // 7
}
