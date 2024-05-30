class _StackNode<T> {
  T data;
  _StackNode<T>? next;

  _StackNode(this.data);
}

class StackLinkedList<T> {
  _StackNode<T>? _top;
  final int _capacity;
  int _size = 0;

  StackLinkedList({int fixedSize = 0}) : _capacity = fixedSize;

  bool get isFull => _size >= _capacity && _capacity > 0;
  bool get isEmpty => _top == null;
  int get size => _size;

  void push(T element) {
    if (isFull) {
      throw StackOverflowError();
    }
    _top = _StackNode<T>(element)..next = _top;
    _size++;
  }

  T pop() {
    if (isEmpty) {
      throw StateError("Cannot pop from an empty stack.");
    }
    final poppedValue = _top!.data;
    _top = _top!.next;
    _size--;
    return poppedValue;
  }

  T peek() {
    if (isEmpty) {
      throw StateError("Cannot peek from an empty stack.");
    }
    return _top!.data;
  }

  void clear() {
    _top = null;
    _size = 0;
  }

  @override
  String toString() {
    if (_top == null) return '[]';
    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    var current = _top;
    while (current!.next != null) {
      buffer.write('${current.data}, ');
      current = current.next;
    }
    buffer.write('${current.data}]');
    return buffer.toString();
  }
}

void main() {
  final stack = StackLinkedList<int>(fixedSize: 4);
  print(stack.isEmpty);
  print(stack.isFull);
  stack.push(1);
  stack.push(2);
  stack.push(3);
  stack.push(5);
  print(stack);
  print(stack.size);
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
