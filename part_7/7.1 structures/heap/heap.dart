class Heap<T extends Comparable<dynamic>> {
  List<T> _heap;
  final bool _isMaxHeap;

  Heap({bool isMaxHeap = true})
      : _heap = [],
        _isMaxHeap = isMaxHeap;

  factory Heap.fromList(
    List<T> list, {
    bool isMaxHeap = true,
  }) {
    Heap<T> heap = Heap<T>(isMaxHeap: isMaxHeap);
    for (T element in list) {
      heap.insert(element);
    }
    return heap;
  }

  int get size => _heap.length;
  bool get isEmpty => _heap.isEmpty;

  void insert(T value) {
    _heap.add(value);
    _heapifyUp(_heap.length - 1);
  }

  T extract() {
    if (_heap.isEmpty) {
      throw StateError('Heap is empty');
    }
    T extractedValue = _heap.first;
    _heap[0] = _heap.last;
    _heap.removeLast();
    _heapifyDown(0);
    return extractedValue;
  }

  T peek() => _heap.first;

  void _heapifyUp(int i) {
    while (i != 0 && _compare(_heap[_parent(i)], _heap[i])) {
      _swap(_parent(i), i);
      i = _parent(i);
    }
  }

  void _heapifyDown(int i) {
    int largestOrSmallest = i;
    int left = _leftChild(i);
    int right = _rightChild(i);

    if (left < size &&
        _compare(
          _heap[largestOrSmallest],
          _heap[left],
        )) {
      largestOrSmallest = left;
    }
    if (right < size &&
        _compare(
          _heap[largestOrSmallest],
          _heap[right],
        )) {
      largestOrSmallest = right;
    }
    if (largestOrSmallest != i) {
      _swap(i, largestOrSmallest);
      _heapifyDown(largestOrSmallest);
    }
  }

  void _swap(int i, int j) {
    T temp = _heap[i];
    _heap[i] = _heap[j];
    _heap[j] = temp;
  }

  bool _compare(T parent, T child) {
    return _isMaxHeap
        ? parent.compareTo(child) < 0
        : parent.compareTo(child) > 0;
  }

  int _leftChild(int i) => 2 * i + 1;
  int _rightChild(int i) => 2 * i + 2;
  int _parent(int i) => (i - 1) ~/ 2;

  void change(int index, T value) {
    if (index < 0 || index >= _heap.length) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }

    var oldValue = _heap[index];
    _heap[index] = value;
    if (_compare(oldValue, value)) {
      _heapifyUp(index);
    } else {
      _heapifyDown(index);
    }
  }

  @override
  String toString() {
    List<String> result = ['Heap\n'];
    if (!isEmpty) {
      _createStrHeap(result, '', 0, true, size);
    }
    return result.join();
  }

  void _createStrHeap(
    List<String> result,
    String prefix,
    int index,
    bool isTail,
    int heapSize,
  ) {
    int leftIndex = _leftChild(index);
    int rightIndex = _rightChild(index);

    if (rightIndex < heapSize) {
      String newPrefix = prefix + (isTail ? '│   ' : '    ');
      _createStrHeap(result, newPrefix, rightIndex, false, heapSize);
    }

    result.add('$prefix${isTail ? '└── ' : '┌── '} ${_heap[index]}\n');

    if (leftIndex < heapSize) {
      String newPrefix = prefix + (isTail ? '    ' : '│   ');
      _createStrHeap(result, newPrefix, leftIndex, true, heapSize);
    }
  }
}

class Worker implements Comparable<Worker> {
  final String name;
  final int age;

  Worker(this.name, this.age);

  @override
  String toString() => 'Worker(name: $name, age: $age)';

  @override
  int compareTo(Worker other) {
    return age.compareTo(other.age);
  }
}

void main() {
  var intList = [1, 2, 3, 40, 55, 6, 7, 8, 9, 10];
  print('*' * 10 + 'Min heap' + '*' * 10);
  var minHeap = Heap.fromList(intList, isMaxHeap: false);
  print(minHeap.peek());
  print(minHeap);
  print(minHeap.extract());
  print('Heap after extract: $minHeap');

  print('*' * 10 + 'Max heap' + '*' * 10);
  var maxHeap = Heap.fromList(intList, isMaxHeap: true);
  print(maxHeap.peek());
  print(maxHeap);
  print(maxHeap.extract());
  print('Heap after extract: $maxHeap');

  print('*' * 10 + 'Min heap' + '*' * 10);
  var workersList = [
    Worker('Alice', 22),
    Worker('Bob', 25),
    Worker('Charlie', 35),
    Worker('David', 40),
    Worker('Eve', 20),
    Worker('Frank', 45),
    Worker('Grace', 23),
    Worker('Henry', 33),
  ];
  var workersMinHeap = Heap.fromList(workersList, isMaxHeap: false);
  print(workersMinHeap.peek());
  print(workersMinHeap);
  print(workersMinHeap.extract());
  print('Heap after extract: $workersMinHeap');

  print('*' * 10 + 'Max heap' + '*' * 10);
  var workersMaxHeap = Heap.fromList(workersList);
  print(workersMaxHeap.peek());
  print(workersMaxHeap);
  print(workersMaxHeap.extract());
  print('Heap after extract: $workersMaxHeap');
}
