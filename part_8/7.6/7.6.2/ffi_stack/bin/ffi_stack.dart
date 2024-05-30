import 'package:ffi_stack/stack.dart';

void main(List<String> arguments) {
  var stack = MyStack();
  print('Stack is empty? - ${stack.isEmpty()}');

  stack.push(42);
  print('Stack is empty? - ${stack.isEmpty()}');

  stack.push(-6);
  stack.push(7);
  stack.push(22);
  stack.push(412);

  while (!stack.isEmpty()) {
    print(stack.pop());
  }

}
