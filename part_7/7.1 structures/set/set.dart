class MySet<T> extends Iterable<T> {
  final Map<T, bool> _map = {};

  @override
  int get length => _map.length;

  @override
  bool get isEmpty => _map.isEmpty;

  void add(T value) {
    _map[value] = true;
  }

  void remove(T value) {
    _map.remove(value);
  }

  bool isContains(T element) => _map.containsKey(element);

  MySet<T> union(MySet<T> other) {
    final combined = MySet<T>();
    combined._map.addAll(_map);
    for (var value in other) {
      combined.add(value);
    }
    return combined;
  }

  MySet<T> intersection(MySet<T> other) {
    final common = MySet<T>();
    for (var value in other) {
      if (contains(value)) {
        common.add(value);
      }
    }
    return common;
  }

  MySet<T> difference(MySet<T> other) {
    final result = MySet<T>();
    for (var value in this) {
      if (!other.contains(value)) {
        result.add(value);
      }
    }
    return result;
  }

  MySet<T> operator +(MySet<T> other) {
    return union(other);
  }

  MySet<T> operator -(MySet<T> other) {
    return difference(other);
  }

  MySet<T> operator *(MySet<T> other) {
    return intersection(other);
  }

  @override
  Iterator<T> get iterator => _SetIterator<T>(_map.keys);

  void clear() {
    _map.clear();
  }

  @override
  String toString() {
    var keys = _map.keys.toSet();
    return keys.toString();
  }
}

class _SetIterator<T> implements Iterator<T> {
  final Iterator<T> _iterator;

  _SetIterator(Iterable<T> iterable) : _iterator = iterable.iterator;

  @override
  T get current => _iterator.current;

  @override
  bool moveNext() => _iterator.moveNext();
}

void main() {
  final setA = MySet<String>();
  setA.add('A');
  setA.add('B');
  setA.add('C');
  setA.add('A');
  print(setA);
  
  final setB = MySet<String>();
  setB.add('A');
  setB.add('G');
  setB.add('T');
  setB.add('G');
  print(setB);

  print(setA - setB);
  print(setA * setB);
  print(setA + setB);

  print(setA.isContains('B'));
   print(setA.isContains('R'));

  setA.remove('A');
  print(setA);
}