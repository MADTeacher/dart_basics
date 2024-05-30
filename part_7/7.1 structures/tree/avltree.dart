import 'dart:math';

class AVLTreeEntry<K extends Comparable<dynamic>, V>
    implements Comparable<AVLTreeEntry<K, V>> {
  K key;
  V value;

  AVLTreeEntry(this.key, this.value);

  @override
  int compareTo(AVLTreeEntry<K, V> other) {
    return key.compareTo(other.key);
  }

  @override
  String toString() {
    return '{$key: $value}';
  }
}

class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? left;
  _Node<T>? right;
  int height = 1;

  _Node(this.data, {this.left, this.right});
}

class AVLTree<K extends Comparable<dynamic>, V>
    extends Iterable<AVLTreeEntry<K, V>> {
  _Node<AVLTreeEntry<K, V>>? _root;

  AVLTree();

  int _height(_Node<AVLTreeEntry<K, V>>? node) {
    return node?.height ?? 0;
  }

  int _balanceFactor(_Node<AVLTreeEntry<K, V>>? node) {
    return _height(node?.right) - _height(node?.left);
  }

  void _updateNodeHeight(_Node<AVLTreeEntry<K, V>>? node) {
    node?.height = 1 +
        max(
          _height(node.left),
          _height(node.right),
        );
  }

  _Node<AVLTreeEntry<K, V>>? _rotateLeft(
    _Node<AVLTreeEntry<K, V>>? node,
  ) {
    _Node<AVLTreeEntry<K, V>>? newRoot = node?.right;
    node?.right = newRoot?.left;
    newRoot?.left = node;
    _updateNodeHeight(node);
    _updateNodeHeight(newRoot);
    return newRoot;
  }

  _Node<AVLTreeEntry<K, V>>? _rotateRight(
    _Node<AVLTreeEntry<K, V>>? node,
  ) {
    _Node<AVLTreeEntry<K, V>>? newRoot = node?.left;
    node?.left = newRoot?.right;
    newRoot?.right = node;
    _updateNodeHeight(node);
    _updateNodeHeight(newRoot);
    return newRoot;
  }

  _Node<AVLTreeEntry<K, V>>? _balance(
    _Node<AVLTreeEntry<K, V>>? node,
  ) {
    if (node == null) {
      return null;
    }
    _updateNodeHeight(node);
    int balance = _balanceFactor(node);
    if (balance >= 2) {
      if (_balanceFactor(node.right) < 0) {
        node.right = _rotateRight(node.right);
      }
      return _rotateLeft(node);
    } else if (balance <= -2) {
      if (_balanceFactor(node.left) > 0) {
        node.left = _rotateLeft(node.left);
      }
      return _rotateRight(node);
    }
    return node;
  }

  void insert(K key, V value) {
    _root = _insert(_root, key, value);
  }

  _Node<AVLTreeEntry<K, V>>? _insert(
      _Node<AVLTreeEntry<K, V>>? node, K key, V value) {
    if (node == null) {
      return _Node<AVLTreeEntry<K, V>>(AVLTreeEntry(key, value));
    } else if (key.compareTo(node.data.key) < 0) {
      node.left = _insert(node.left, key, value);
    } else if (key.compareTo(node.data.key) > 0) {
      node.right = _insert(node.right, key, value);
    } else {
      node.data.value = value;
    }
    return _balance(node);
  }

  void operator []=(K key, V value) {
    insert(key, value);
  }

  V? operator [](K key) {
    _Node<AVLTreeEntry<K, V>>? node = _root;
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
    var node = this[key];
    return node != null;
  }

  void remove(K key) {
    _root = _remove(_root, key);
  }

  _Node<AVLTreeEntry<K, V>>? _remove(
    _Node<AVLTreeEntry<K, V>>? node,
    K key,
  ) {
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
      }
      node.data = _minNode(node.right)!.data;
      node.right = _remove(node.right, node.data.key);
    }
    _balance(node);
    return node;
  }

  _Node<AVLTreeEntry<K, V>>? _minNode(
    _Node<AVLTreeEntry<K, V>>? node,
  ) {
    if (node?.left == null) {
      return node;
    }
    return _minNode(node?.left);
  }

  void clear() {
    _root = null;
  }

  AVLTreeEntry<K, V> minimum() {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node?.left != null) {
      node = node!.left;
    }
    return node!.data;
  }

  AVLTreeEntry<K, V> maximum() {
    _Node<AVLTreeEntry<K, V>>? node = _root;
    while (node?.right != null) {
      node = node!.right;
    }
    return node!.data;
  }

  @override
  bool get isEmpty => _root == null;

  @override
  Iterator<AVLTreeEntry<K, V>> get iterator => _AVLTreeIterator(_root);

  @override
  String toString() {
    List<String> result = ['AVLTree\n'];
    if (!isEmpty) {
      _createStrTree(result, '', _root, true);
    }
    return result.join();
  }

  void _createStrTree(
    List<String> result,
    String prefix,
    _Node<AVLTreeEntry<K, V>>? node,
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

class _AVLTreeIterator<K extends Comparable<dynamic>, V>
    implements Iterator<AVLTreeEntry<K, V>> {
  final List<_Node<AVLTreeEntry<K, V>>> _stack = [];
  _Node<AVLTreeEntry<K, V>>? _currentNode;

  _AVLTreeIterator(_Node<AVLTreeEntry<K, V>>? root) {
    _pushLeft(root);
  }

  @override
  AVLTreeEntry<K, V> get current => _currentNode!.data;

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

  void _pushLeft(_Node<AVLTreeEntry<K, V>>? node) {
    while (node != null) {
      _stack.add(node);
      node = node.left;
    }
  }
}

void main() {
  var tree = AVLTree<int, String>();
  tree[5] = 'a';
  tree[12] = 'b';
  tree[3] = 'c';
  tree[14] = 'd';
  tree[25] = 'e';
  tree[16] = 'f';
  tree[24] = 'd';
  tree[26] = 'e';
  tree[19] = 'f';

  print(tree);

  print('Change value');
  tree[3] = 'x';
  print(tree);

  print('Delete');
  tree.remove(24);
  print(tree);

  print(tree.minimum());
  print(tree.maximum());
  print(tree.containsKey(12));
  print(tree.containsKey(100));
  print(tree.length);
}
