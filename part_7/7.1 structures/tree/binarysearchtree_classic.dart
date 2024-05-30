class _Node<T extends Comparable<dynamic>> {
  T data;
  _Node<T>? left;
  _Node<T>? right;

  _Node(this.data, {this.left, this.right});

  @override
  String toString() {
    return '$data';
  }
}

class BinarySearchTree<T extends Comparable<dynamic>> {
  _Node<T>? _root;
  int _length = 0;

  BinarySearchTree();

  bool get isEmpty => _root == null;
  int get length => _length;

  void insert(T data) {
    _root = _insert(_root, data);
  }

  _Node<T>? _insert(_Node<T>? node, T data) {
    if (node == null) {
      _length++;
      return _Node<T>(data);
    } else if (data.compareTo(node.data) < 0) {
      node.left = _insert(node.left, data);
    } else if (data.compareTo(node.data) > 0) {
      node.right = _insert(node.right, data);
    } else {
      node.data = data;
    }
    return node;
  }

  T? find(T data) {
    _Node<T>? node = _root;
    while (node != null) {
      if (data.compareTo(node.data) < 0) {
        node = node.left;
      } else if (data.compareTo(node.data) > 0) {
        node = node.right;
      } else {
        return node.data;
      }
    }
    return null;
  }

  bool containsKey(T data) {
    return find(data) != null;
  }

  T minimum() {
    if (_root == null) {
      throw StateError('Tree is empty');
    }
    _Node<T>? node = _root;
    while (node?.left != null) {
      node = node!.left;
    }
    return node!.data;
  }

  T maximum() {
    if (_root == null) {
      throw StateError('Tree is empty');
    }
    _Node<T>? node = _root;
    while (node?.right != null) {
      node = node!.right;
    }
    return node!.data;
  }

  void remove(T value) {
    _root = _remove(_root, value);
    if (_root != null) {
      _length--;
    }
  }

  _Node<T>? _remove(_Node<T>? node, T value) {
    if (node == null) {
      return null;
    } else if (value.compareTo(node.data) < 0) {
      node.left = _remove(node.left, value);
    } else if (value.compareTo(node.data) > 0) {
      node.right = _remove(node.right, value);
    } else {
      if (node.left == null) {
        return node.right;
      } else if (node.right == null) {
        return node.left;
      } else {
        _Node<T>? minNode = _findMinNode(node.right);
        node.data = minNode!.data;
        node.right = _remove(node.right, minNode.data);
      }
    }
    return node;
  }

  _Node<T>? _findMinNode(_Node<T>? node) {
    if (node == null) {
      return null;
    } else if (node.left == null) {
      return node;
    } else {
      return _findMinNode(node.left);
    }
  }

  void clear() {
    _root = null;
  }

  void forEach(void Function(T) func) {
    var node = _root;
    if (node == null) {
      throw StateError('Tree is empty');
    }
    _forEach(node, func);
  }

  void _forEach(_Node<T>? node, void Function(T) func) {
    if (node == null) {
      return;
    }
    _forEach(node.left, func);
    func(node.data);
    _forEach(node.right, func);
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
    _Node<T>? node,
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
  var tree = BinarySearchTree<int>();
  var list = <int>[80, 55, 95, 59, 88, 96, 57, 31, 20];
  for (var it in list) {
    tree.insert(it);
  }

  print(tree);

  print('Delete key = 20');
  tree.remove(80);
  print(tree);

  print(tree.minimum());
  print(tree.maximum());
  print(tree.containsKey(57));
  print(tree.containsKey(100));
  print(tree.find(20));

  print('*' * 20);
  var workersList = <Worker>[
    Worker('Alice', 80),
    Worker('Bob', 62),
    Worker('Ivan', 20),
    Worker('Charlie', 63),
    Worker('David', 106),
    Worker('Eve', 59),
    Worker('Frank', 95),
    Worker('Grace', 57),
    Worker('Henry', 31),
    Worker('Jack', 88),
    Worker('Stas', 96),
  ];

  var workersTree = BinarySearchTree<Worker>();
  for (var it in workersList) {
    workersTree.insert(it);
  }
  print(workersTree);

  print('Delete worker with id = 20');
  workersTree.remove(Worker('', 20));
  print(workersTree);

  print(workersTree.minimum());
  print(workersTree.maximum());

  print('Find worker with id = 96');
  print(workersTree.find(Worker('', 96)));

  print('forEach worker');
  workersTree.forEach((worker) {
    print(worker);
  });
}
