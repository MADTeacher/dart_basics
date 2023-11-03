import 'i_attribute.dart';
import 'user.dart';

final class _Node<T extends IAttribute> {
  T data;
  _Node? next;

  _Node(this.data, [this.next]);

  @override
  String toString() {
    return data.toString();
  }
}

final class Table<T extends IAttribute> {
  _Node? _head;
  _Node? _tail;

  String title;

  Table(this.title);

  T? get last => _tail?.data as T;
  T? get first => _head?.data as T;

  bool contains(T data) {
    var temp = _head;
    if (data is User) {
      while (temp != null) {
        if (temp.data.check(
          'id',
          data.id.toString(),
        )) {
          return true;
        }
        temp = temp.next;
      }
    }
    return false;
  }

  bool insert(T data) {
    var node = _Node(data);
    if (_head == null) {
      _head = node;
      _tail = node;
      return true;
    } else if (!contains(data)) {
      _tail?.next = node;
      _tail = node;
      return true;
    }
    return false;
  }

  void remove(String id) {
    var current = _head;
    _Node? prev;

    while (current != null &&
        !(current.data.check(
          UserTableFields.id.text,
          id,
        ))) {
      prev = current;
      current = current.next;
    }

    if (current == null) {
      return;
    }

    prev?.next = current.next;
  }

  Table<T> intersect(
    String attribute,
    String value,
    Table<T> table,
  ) {
    var newTable = Table<T>('$title-${table.title}');
    var temp = _head;
    while (temp != null) {
      if (temp.data.check(attribute, value)) {
        newTable.insert(temp.data as T);
      }
      temp = temp.next;
    }

    temp = table._head;
    while (temp != null) {
      if (temp.data.check(attribute, value)) {
        if (!newTable.contains(temp.data as T)) {
          newTable.insert(temp.data as T);
        }
      }
      temp = temp.next;
    }
    return newTable;
  }

  Table<T> union(Table<T> table) {
    var newTable = Table<T>('$title-${table.title}');
    var temp = _head;

    while (temp != null) {
      newTable.insert(temp.data as T);
      temp = temp.next;
    }

    temp = table._head;
    while (temp != null) {
      if (!newTable.contains(temp.data as T)) {
        newTable.insert(temp.data as T);
      }
      temp = temp.next;
    }

    return newTable;
  }

  Table<T> selection(String attribute, String value) {
    var newTable = Table<T>('$title-new');
    var temp = _head;

    while (temp != null) {
      if (temp.data.check(attribute, value)) {
        newTable.insert(temp.data as T);
      }
      temp = temp.next;
    }

    return newTable;
  }

  void forEach(void Function(T data) action) {
    var temp = _head;
    while (temp != null) {
      action(temp.data as T);
      temp = temp.next;
    }
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    var temp = _head;
    buffer.writeln('${'*' * 10}$title${'*' * 10}');
    while (temp != null) {
      buffer.writeln(temp.data);
      temp = temp.next;
    }
    return buffer.toString();
  }
}
