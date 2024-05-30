class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

({int index, T? value}) ternarySearch<T>(
    List<T> list, int Function(T element) compare) {
  // проверяем, что искомое значение может находиться в коллекции
  if (compare(list.last) < 0 || compare(list.first) > 0 || list.isEmpty) {
    return (index: -1, value: null);
  }

  return _ternarySearch_impl(list, compare, 0, list.length - 1);
}

({int index, T? value}) _ternarySearch_impl<T>(
  List<T> list,
  int Function(T element) compare,
  int left,
  int right,
) {
  if (right > left) {
    if (right - left == 1) {
      if (compare(list[left]) == 0) {
        return (index: left, value: list[left]);
      }
      if (compare(list[right]) == 0) {
        return (index: right, value: list[right]);
      }
      return (index: -1, value: null);
    }

    var step = (right - left) < 3  ? 1 : ((right - left) ~/ 3);
    var middle1 = left + step;
    var middle2 = middle1 + step;
    if (compare(list[middle1]) == 0) {
      return (index: middle1, value: list[middle1]);
    } 
    
    if (compare(list[middle2]) == 0) {
      return (index: middle2, value: list[middle2]);
    } 
    
    if (compare(list[middle1]) > 0) {
      return _ternarySearch_impl(list, compare, left, middle1);
    } else if (compare(list[middle1]) > 0 && compare(list[middle2]) < 0) {
      return _ternarySearch_impl(list, compare, middle2, middle2);
    } else {
      return _ternarySearch_impl(list, compare, middle2, right);
    }
  }
  return (index: -1, value: null);
}

void main() {
  List<int> list = [64, 34, 25, 12, 90, 11, 22];
  list.sort((a, b) => a.compareTo(b));
  print(list);

  var val = ternarySearch(list, (i) => i.compareTo(90));
  print('Index: ${val.index}, Value: ${val.value}');
  val = ternarySearch(list, (i) => i.compareTo(100));
  print('Index: ${val.index}, Value: ${val.value}');
  print('*' * 20);

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
  var worker = ternarySearch(workers, (w) => w.id.compareTo(52));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = ternarySearch(workers, (w) => w.id.compareTo(100));
  print('Index: ${worker.index}, Value: ${worker.value}');

  // Поиск по имени
  workers.sort((a, b) => a.name.compareTo(b.name));
  worker = ternarySearch(workers, (w) => w.name.compareTo('Alice'));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = ternarySearch(workers, (w) => w.name.compareTo('John'));
  print('Index: ${worker.index}, Value: ${worker.value}');
}
