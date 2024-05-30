class _Node<T> {
  T data;
  _Node<T>? next;

  _Node(this.data, {this.next});
}

class SinglyLinkedQueue<T> {
  _Node<T>? _head;
  _Node<T>? _tail;
  int _size = 0;
  final int? _fixedSize;

  SinglyLinkedQueue({int? fixedSize}) : _fixedSize = fixedSize;

  bool get isEmpty => _size == 0;
  bool get isFull => _fixedSize != null && _size >= _fixedSize;
  int get size => _size;

  void enqueue(T value) {
    if (isFull) {
      throw StateError('Queue is full');
    }
    var newNode = _Node(value);
    if (isEmpty) {
      _head = _tail = newNode;
    } else {
      _tail!.next = newNode;
      _tail = newNode;
    }
    _size++;
  }

  T dequeue() {
    if (isEmpty) {
      throw StateError('Queue is empty');
    }
    var value = _head!.data;
    _head = _head!.next;
    if (_head == null) {
      _tail = null;
    }
    _size--;
    return value;
  }

  T peek() {
    if (isEmpty) {
      throw StateError('Queue is empty');
    }
    return _head!.data;
  }

  void clear() {
    _head = _tail = null;
    _size = 0;
  }

  @override
  String toString() {
    if (_head == null) return '[]';
    StringBuffer buffer = StringBuffer();
    buffer.write('[');
    var current = _head;
    while (current!.next != null) {
      buffer.write('${current.data}, ');
      current = current.next;
    }
    buffer.write('${current.data}]');
    return buffer.toString();
  }
}

void main() {
  var queue = SinglyLinkedQueue(fixedSize: 4);
  print(queue.isEmpty);
  print(queue.isFull);
  queue.enqueue(1);
  queue.enqueue(2);
  queue.enqueue(3);
  queue.enqueue(6);
  print(queue);
  print(queue.peek());

  try {
    queue.enqueue(4);
  } on StateError catch (e) {
    print(e);
  }

  print(queue.isFull);
  print(queue.isEmpty);

  try {
    for (int i = 0; i < 5; i++) {
      print(queue.dequeue()); // 1, 2, 3, 6
    }
  } on StateError catch (e) {
    print(e);
  }

  print(queue);
}