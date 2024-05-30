class StackArray<T> {
  final List<T?> _items;
  final int _capacity;
  int _top = -1;

  // если fixedSize не задано стек - динамический
  StackArray({int fixedSize = 0})
      : _capacity = fixedSize,
        _items = List<T?>.filled(
          fixedSize,
          null,
          growable: fixedSize == 0,
        );

  bool get isFull => _top >= _capacity - 1 && _capacity > 0;
  bool get isEmpty => _top < 0;
  int get length => _top + 1;

  void push(T element) {
    if (_capacity == 0) {
      _items.add(element);
      _top++;
    } else {
      if (isFull) {
        throw StackOverflowError();
      } else {
        _items[++_top] = element;
      }
    }
  }

  T pop() {
    if (isEmpty) {
      throw StateError("Cannot pop from an empty stack.");
    } else {
      T? poppedElement = _items[_top];
      _items[_top--] = null;
      return poppedElement as T;
    }
  }

  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek from an empty stack.");
    } else {
      return _items[_top] as T;
    }
  }

  void clear() {
    _items.clear();
  }

  @override
  String toString() {
    return _items.toString();
  }
}

void main() {
  final stack = StackArray<int>(fixedSize: 4);
  print(stack.isEmpty);
  print(stack.isFull);
  stack.push(1);
  stack.push(2);
  stack.push(3);
  stack.push(5);
  print(stack);
  print(stack.length);
  print(stack.peek());
  print(stack.pop());
  print(stack);

  try {
    stack.push(4);
    stack.push(4);
  } on StackOverflowError catch (e) {
    print(e);
  }

  print(stack.isFull);
  print(stack.isEmpty);

  try {
    for (int i = 0; i < 5; i++) {
      stack.pop();
    }
  } on StateError catch (e) {
    print(e);
  }
}
