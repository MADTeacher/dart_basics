class ArrayQueue<T> {
  List<T?> _queue;
  int _head = 0;
  int _tail = 0;
  final int? _fixedSize;

  ArrayQueue({int? fixedSize})
      : _fixedSize = fixedSize,
        _queue = List<T?>.filled(
          fixedSize ?? 16,
          null,
          growable: fixedSize == null,
        );

  void enqueue(T element) {
    if (_tail == _queue.length && _fixedSize == null) {
      _queue.length *= 2; // увеличиваем длину массива
    }
    if (_tail - _head == _fixedSize) {
      throw StateError('Queue is full');
    }
    _queue[_tail++ % _queue.length] = element;
  }

  T dequeue() {
    if (_head == _tail) {
      throw StateError('Queue is empty');
    }
    var element = _queue[_head % _queue.length];
    _queue[_head++ % _queue.length] = null;
    if (_fixedSize == null &&
        _tail - _head > 16 &&
        (_tail - _head) * 4 < _queue.length) {
      _tail -= _head;
      _head = 0;
      _queue = _queue.sublist(_head, _tail);
    }
    return element!;
  }

  T peek() {
    if (_head == _tail) {
      throw StateError('Queue is empty');
    }
    return _queue[_head % _queue.length]!;
  }

  bool get isEmpty => _head == _tail;
  bool get isFull => _tail - _head == _fixedSize;
  int get size => _tail - _head;

  void clear(){
    _queue = List<T?>.filled(
      _queue.length,
      null,
      growable: _fixedSize == null,
    );
  }
  
  @override
  String toString() {
    return _queue.toString();
  }
}

void main() {
  var queue = ArrayQueue(fixedSize: 4);
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