typedef int MyFunctionAdd(int a, int b);

int add(int a, int b) => a + b;

void main(List<String> arguments) {
  var newAddFunction = add;
  var newSubFunction = (int c, int a, int b, MyFunctionAdd func) {
   return c - func(a, b);
  };
  print(newSubFunction(30, 21, 2, newAddFunction)); // 7
}
