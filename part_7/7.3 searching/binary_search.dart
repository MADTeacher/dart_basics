class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

({int index, T? value}) binarySearch<T>(
    List<T> list, int Function(T element) compare) {
  // проверяем, что искомое значение может находиться в коллекции
  if (compare(list.last) < 0 || compare(list.first) > 0 || list.isEmpty) {
    return (index: -1, value: null);
  }

  return _binarySearch_impl(list, compare, 0, list.length - 1);
}

({int index, T? value}) _binarySearch_impl<T>(
  List<T> list,
  int Function(T element) compare,
  int left,
  int right,
) {
  if (left > right) {
    return (index: -1, value: null);
  }
  int middle = (left + right) ~/ 2;
  if (compare(list[middle]) < 0) {
    return _binarySearch_impl(list, compare, middle + 1, right);
  } else if (compare(list[middle]) > 0) {
    return _binarySearch_impl(list, compare, left, middle - 1);
  } else {
    return (index: middle, value: list[middle]);
  }
}

void main() {
  List<int> list = [64, 34, 25, 12, 90, 11, 22];
  list.sort((a,b) => a.compareTo(b));
  print(list);

  var val = binarySearch(list, (i) => i.compareTo(90));
  print('Index: ${val.index}, Value: ${val.value}');
  val = binarySearch(list, (i) => i.compareTo(100));
  print('Index: ${val.index}, Value: ${val.value}');
  print('*'*20);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];

  // Поиск по id
  workers.sort((a, b) => a.id.compareTo(b.id));
  var worker = binarySearch(workers, (w) => w.id.compareTo(52));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = binarySearch(workers, (w) => w.id.compareTo(100));
  print('Index: ${worker.index}, Value: ${worker.value}');

  // Поиск по имени
  workers.sort((a, b) => a.name.compareTo(b.name));
  worker = binarySearch(workers, (w) => w.name.compareTo('Alice'));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = binarySearch(workers, (w) => w.name.compareTo('John'));
  print('Index: ${worker.index}, Value: ${worker.value}');
}
