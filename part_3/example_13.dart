typedef int MyFunctionAdd(int a, int b);

int add(int a, int b){
  return a + b;
}

int sub(int c, int a, int b, MyFunctionAdd func){
  return c - func(a, b);
}

void main(List<String> arguments) {
  print(sub(30, 21, 2, add)); // 7
}
