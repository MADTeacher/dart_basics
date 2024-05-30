class Heap<T> {
  List<T> _heap;
  bool Function(T, T) _compare;

  Heap(this._compare)
      : _heap = [];

  factory Heap.fromList(
    List<T> list, bool Function(T, T) compare) {
    Heap<T> heap = Heap<T>(compare);
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
    while (i != 0 && _comp(_heap[_parent(i)], _heap[i])) {
      _swap(_parent(i), i);
      i = _parent(i);
    }
  }

  void _heapifyDown(int i) {
    int largestOrSmallest = i;
    int left = _leftChild(i);
    int right = _rightChild(i);

    if (left < size &&
        _comp(
          _heap[largestOrSmallest],
          _heap[left],
        )) {
      largestOrSmallest = left;
    }
    if (right < size &&
        _comp(
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

  bool _comp(T parent, T child) {
    return _compare(parent, child);
  }

  int _leftChild(int i) => 2 * i + 1;
  int _rightChild(int i) => 2 * i + 2;
  int _parent(int i) => (i - 1) ~/ 2;
}

// сортировка кучей
extension HeapSort<T> on List<T> {
  void heapSort(bool Function(T, T) compare) {
    Heap<T> heap = Heap.fromList(this, compare);
    for (int i = 0; i < this.length; i++) {
      this[i] = heap.extract();
    }
  }
}

class Worker {
  final String name;
  final int age;

  Worker(this.name, this.age);

  @override
  String toString() => 'Worker(name: $name, age: $age)';
}

void main() {
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.heapSort((a, b) => a < b);
  print(list);

  list.heapSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.heapSort((a, b) => a.age < b.age);
  print(workers);

  workers.heapSort((a, b) => a.name.compareTo(b.name) > 0);
  print(workers);
}
