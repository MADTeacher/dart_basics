class BinaryTreeEntry<K extends Comparable<dynamic>, V>
    implements Comparable<BinaryTreeEntry<K, V>> {
  K key;
  V value;

  BinaryTreeEntry(this.key, this.value);

  @override
  int compareTo(BinaryTreeEntry<K, V> other) {
    return key.compareTo(other.key);
  }

  @override
  String toString() {
    return '{$key: $value}';
  }
}

class _Node<T> {
  T data;
  _Node<T>? left;
  _Node<T>? right;

  _Node(this.data, {this.left, this.right});
}

class BinarySearchTree<K extends Comparable<dynamic>, V>
    extends Iterable<BinaryTreeEntry<K, V>> {
  _Node<BinaryTreeEntry<K, V>>? _root;

  BinarySearchTree();

  void insert(K key, V value) {
    _root = _insert(_root, key, value);
  }

  _Node<BinaryTreeEntry<K, V>>? _insert(
      _Node<BinaryTreeEntry<K, V>>? node, K key, V value) {
    if (node == null) {
      return _Node(BinaryTreeEntry(key, value));
    } else if (key.compareTo(node.data.key) < 0) {
      node.left = _insert(node.left, key, value);
    } else if (key.compareTo(node.data.key) > 0) {
      node.right = _insert(node.right, key, value);
    } else {
      node.data.value = value;
    }
    return node;
  }

  void operator []=(K key, V value) {
    insert(key, value);
  }

  V? operator [](K key) {
    _Node<BinaryTreeEntry<K, V>>? node = _root;
    while (node != null) {
      if (key.compareTo(node.data.key) < 0) {
        node = node.left;
      } else if (key.compareTo(node.data.key) > 0) {
        node = node.right;
      } else {
        return node.data.value;
      }
    }
    return null;
  }

  bool containsKey(K key) {
    return this[key] != null;
  }

  void remove(K key) {
    _root = _remove(_root, key);
  }

  _Node<BinaryTreeEntry<K, V>>? _remove(
      _Node<BinaryTreeEntry<K, V>>? node, K key) {
    if (node == null) {
      return null;
    } else if (key.compareTo(node.data.key) < 0) {
      node.left = _remove(node.left, key);
    } else if (key.compareTo(node.data.key) > 0) {
      node.right = _remove(node.right, key);
    } else {
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      } else {
        _Node<BinaryTreeEntry<K, V>>? minNode = _findMinNode(node.right);
        node.data = minNode!.data;
        node.right = _remove(node.right, minNode.data.key);
      }
    }
    return node;
  }

  _Node<BinaryTreeEntry<K, V>>? _findMinNode(
      _Node<BinaryTreeEntry<K, V>>? node) {
    if (node == null) {
      return null;
    } else if (node.left == null) {
      return node;
    } else {
      return _findMinNode(node.left);
    }
  }

  BinaryTreeEntry<K, V> minimum() {
    _Node<BinaryTreeEntry<K, V>>? node = _root;
    while (node?.left != null) {
      node = node!.left;
    }
    return node!.data;
  }

  BinaryTreeEntry<K, V> maximum() {
    _Node<BinaryTreeEntry<K, V>>? node = _root;
    while (node?.right != null) {
      node = node!.right;
    }
    return node!.data;
  }

  @override
  bool get isEmpty => _root == null;

  @override
  Iterator<BinaryTreeEntry<K, V>> get iterator =>
      _BinarySearchTreeIterator(_root);

  void clear() {
    _root = null;
  }

  @override
  String toString() {
    List<String> result = ['BinarySearchTree\n'];
    if (!isEmpty) {
      _createStrTree(result, '', _root, true);
    }
    return result.join();
  }

  void _createStrTree(
    List<String> result,
    String prefix,
    _Node<BinaryTreeEntry<K, V>>? node,
    bool isTail,
  ) {
    if (node?.right != null) {
      String newPrefix = prefix + (isTail ? '│   ' : '    ');
      _createStrTree(result, newPrefix, node!.right, false);
    }

    result.add('$prefix${isTail ? '└── ' : '┌── '} ${node?.data}\n');

    if (node?.left != null) {
      String newPrefix = prefix + (isTail ? '    ' : '│   ');
      _createStrTree(result, newPrefix, node!.left, true);
    }
  }
}

class _BinarySearchTreeIterator<K extends Comparable<dynamic>, V>
    implements Iterator<BinaryTreeEntry<K, V>> {
  final List<_Node<BinaryTreeEntry<K, V>>> _stack = [];
  _Node<BinaryTreeEntry<K, V>>? _currentNode;

  _BinarySearchTreeIterator(_Node<BinaryTreeEntry<K, V>>? root) {
    _pushLeft(root);
  }

  @override
  BinaryTreeEntry<K, V> get current => _currentNode!.data;

  @override
  bool moveNext() {
    if (_stack.isEmpty) {
      _currentNode = null;
      return false;
    }
    _currentNode = _stack.removeLast();
    _pushLeft(_currentNode!.right);
    return true;
  }

  void _pushLeft(_Node<BinaryTreeEntry<K, V>>? node) {
    while (node != null) {
      _stack.add(node);
      node = node.left;
    }
  }
}

void main() {
  var tree = BinarySearchTree<int, String>();
  tree[5] = 'a';
  tree[12] = 'b';
  tree[3] = 'c';
  tree[14] = 'd';
  tree[25] = 'e';
  tree[16] = 'f';
  print(tree);

  print('Change value');
  tree[3] = 'x';
  print(tree);

  print('Delete');
  tree.remove(5);
  print(tree);

  print(tree.minimum());
  print(tree.maximum());
  print(tree.containsKey(12));
  print(tree.containsKey(100));
  print(tree.length);
}
