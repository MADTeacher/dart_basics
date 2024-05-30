class HashTableEntry<K, V> {
  K key;
  V value;

  HashTableEntry(this.key, this.value);
}

class _Node<T> {
  T data;
  _Node<T>? next;

  _Node(this.data, {this.next});
}

class HashTable<K, V> extends Iterable<HashTableEntry<K, V>> {
  static const int _defaultSize = 16;
  final int _initialCapacity;
  List<_Node<HashTableEntry<K, V>>?> _buckets;
  int _size = 0;

  HashTable([this._initialCapacity = _defaultSize])
      : _buckets = List<_Node<HashTableEntry<K, V>>?>.filled(
          _initialCapacity,
          null,
        );

  @override
  int get length => _size;

  @override
  bool get isEmpty => _size == 0;

  int _getBucketIndex(K key) {
    int hashCode = key.hashCode;
    return hashCode % _buckets.length;
  }

  void add(K key, V value) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    while (node != null) {
      if (node.data.key == key) {
        node.data.value = value; // замена значения по ключу 
        return;
      }
      node = node.next;
    }
    _buckets[index] = _Node<HashTableEntry<K, V>>(
      HashTableEntry(key, value),
      next: _buckets[index],
    );
    _size++;
  }

  void operator []=(K key, V value) {
    add(key, value);
  }

  V? get(K key) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    while (node != null) {
      if (node.data.key == key) {
        return node.data.value;
      }
      node = node.next;
    }
    return null;
  }

  V? operator [](K key) {
    return get(key);
  }

  bool containsKey(K key) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    while (node != null) {
      if (node.data.key == key) {
        return true;
      }
      node = node.next;
    }
    return false;
  }

  V? remove(K key) {
    int index = _getBucketIndex(key);
    _Node<HashTableEntry<K, V>>? node = _buckets[index];
    _Node<HashTableEntry<K, V>>? prevNode;
    while (node != null) {
      if (node.data.key == key) {
        if (prevNode == null) {
          _buckets[index] = node.next;
        } else {
          prevNode.next = node.next;
        }
        _size--;
        return node.data.value;
      }
      prevNode = node;
      node = node.next;
    }
    return null;
  }

  @override
  Iterator<HashTableEntry<K, V>> get iterator => _HashTableIterator<K, V>(this);

  void clear() {
    _buckets = List<_Node<HashTableEntry<K, V>>?>.filled(
      _initialCapacity,
      null,
    );
    _size = 0;
  }

  @override
  String toString() {
    if (isEmpty) return '{}';

    StringBuffer buffer = StringBuffer();
    buffer.write('{');
    Iterator<HashTableEntry<K, V>> iterator = this.iterator;
    if (iterator.moveNext()) {
      while (true) {
        HashTableEntry<K, V> entry = iterator.current;
        if (iterator.moveNext()) {
          buffer.write('${entry.key}: ${entry.value}, ');
        } else {
          buffer.write('${entry.key}: ${entry.value}');
          break;
        }
      }
    }
    buffer.write('}');
    return buffer.toString();
  }
}

class _HashTableIterator<K, V> implements Iterator<HashTableEntry<K, V>> {
  final HashTable<K, V> _hashTable;
  final int _bucketCount;
  int _currentBucket = 0;
  _Node<HashTableEntry<K, V>>? _currentNode;
  bool _isIterationStarted = false;

  _HashTableIterator(this._hashTable)
      : _bucketCount = _hashTable._buckets.length;

  @override
  HashTableEntry<K, V> get current => _currentNode!.data;

  @override
  bool moveNext() {
    if (!_isIterationStarted) {
      _isIterationStarted = true;
      _currentBucket = 0;
      _currentNode = _hashTable._buckets[_currentBucket];
    } else if (_currentNode != null) {
      _currentNode = _currentNode!.next;
    }

    while (_currentNode == null && _currentBucket < _bucketCount - 1) {
      _currentBucket++;
      _currentNode = _hashTable._buckets[_currentBucket];
    }

    return _currentNode != null;
  }
}

void main() {
  var hashtable = HashTable<int, String>();
  hashtable[1] = 'A';
  hashtable[2] = 'B';
  hashtable[3] = 'C';
  hashtable[4] = 'A';

  print(hashtable);

  hashtable.remove(4);
  print(hashtable);

  hashtable[1] = 'T';
  print(hashtable[1]);
  print(hashtable.contains(1));
  print(hashtable[7]);

  for(var HashTableEntry(:key, :value) in hashtable) {
    print('$key: $value');
  }
}