class DynamicArray<T extends Comparable<dynamic>> extends Iterable<T> {
  List<T?> _elements;
  int _size = 0;

  DynamicArray(int initialCapacity)
      : _elements = List<T?>.filled(initialCapacity, null);

  @override
  bool get isEmpty => _size == 0;

  @override
  int get length => _size;

  int get capacity => _elements.length;

  void add(T value) {
    if (_size == _elements.length) {
      _resize();
    }
    _elements[_size++] = value;
  }

  T pop() {
    if (_size == 0) {
      throw UnsupportedError('List is empty');
    }
    _size--;
    var value = _elements[_size];
    _elements[_size] = null;
    return value!;
  }

  void insert(int index, T value) {
    if (index < 0 || index > _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    if (_size == _elements.length) {
      _resize();
    }
    for (int i = _size; i > index; i--) {
      _elements[i] = _elements[i - 1];
    }
    _elements[index] = value;
    _size++;
  }

  @override
  T elementAt(int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    return _elements[index]!;
  }

  void set(int index, T value) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    _elements[index] = value;
  }

  void operator []=(int index, T value) {
    set(index, value);
  }

  T operator [](int index) {
    return elementAt(index);
  }

  void removeAt(int index) {
    if (index < 0 || index >= _size) {
      throw RangeError.index(index, this, 'Index out of bounds');
    }
    for (int i = index; i < _size - 1; i++) {
      _elements[i] = _elements[i + 1];
    }
    _elements[_size - 1] = null;
    _size--;
  }

  void remove(T value) {
    for (int i = 0; i < _size; i++) {
      if (_elements[i]!.compareTo(value) == 0) {
        removeAt(i);
        break;
      }
    }
  }

  void _resize() {
    int newCapacity = _elements.length * 2;
    List<T?> newElements = List<T?>.filled(newCapacity, null);
    for (int i = 0; i < _size; i++) {
      newElements[i] = _elements[i];
    }
    _elements = newElements;
  }

  @override
  Iterator<T> get iterator => _DynamicArrayIterator<T>(this);

  void clear() {
    _elements = List<T?>.filled(_elements.length, null);
    _size = 0;
  }

  @override
  String toString() {
    if (_size == 0) {
      return '[]';
    }
    StringBuffer sb = StringBuffer();
    sb.write('[');
    for (int i = 0; i < _size; i++) {
      if (i != 0) {
        sb.write(', ${_elements[i]}');
      } else {
        sb.write('${_elements[i]}');
      }
    }
    sb.write(']');
    return sb.toString();
  }
}

class _DynamicArrayIterator<T extends Comparable<dynamic>> implements Iterator<T> {
  /// Класс _DynamicArrayIterator предназначен для итерации по 
  /// элементам экземпляра DynamicArray. Он реализует интерфейс 
  /// Iterator<T>, который является частью стандартной библиотеки 
  /// Dart для создания итераторов, позволяющих перебирать 
  /// элементы коллекции.
  final DynamicArray<T> _dynamicArray;
  int _currentIndex = -1;

  _DynamicArrayIterator(this._dynamicArray);

  @override
  T get current => _dynamicArray.elementAt(_currentIndex);

  @override
  bool moveNext() {
    if (_currentIndex < _dynamicArray.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }
}

class Worker implements Comparable<Worker> {
  final String name;
  final int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';

  @override
  int compareTo(Worker other) {
    return id.compareTo(other.id);
  }
}

void main() {
  var workers = DynamicArray<Worker>(3);
  workers.add(Worker('Alice', 1));
  workers.add(Worker('Bob', 2));
  workers.add(Worker('Charlie', 3));
  print('Capacity: ${workers.capacity}'); // Capacity: 3
  workers.add(Worker('David', 4));
  print('Capacity: ${workers.capacity}'); // Capacity: 6
  workers.add(Worker('Eve', 5));

  print(workers);
  print('Number of workers: ${workers.length}'); //
  workers
      .remove(Worker('Alice', 1)); 
  print(workers);

  print('Worker at index 0: ${workers.elementAt(0)}');

  workers[1] = Worker('Stas', 11);
  print('Worker at index 1: ${workers[1]}');
  print(workers.where((element) => element.id >= 5));

  print('*'*20);
  for (Worker worker in workers) {
    print(worker);
  }
  print('*'*20);
  workers.clear();
  print(workers.length); // 0
}
