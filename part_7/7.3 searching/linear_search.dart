class Worker {
  String name;
  int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

({int index, T? value}) linearSearch<T>(
    List<T> list, int Function(T element) toCompare) {
  for (int i = 0; i < list.length; i++) {
    if (toCompare(list[i]) == 0) {
      return (index: i, value: list[i]);
    } else if (toCompare(list[i]) > 0) {
      break;
    }
  }
  return (index: -1, value: null);
}

void main() {
  List<int> list = [64, 34, 25, 12, 90, 11, 22];
  list.sort((a,b) => a.compareTo(b));
  print(list);

  var val = linearSearch(list, (i) => i.compareTo(90));
  print('Index: ${val.index}, Value: ${val.value}');
  val = linearSearch(list, (i) => i.compareTo(100));
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
  var worker = linearSearch(workers, (w) => w.id.compareTo(52));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = linearSearch(workers, (w) => w.id.compareTo(100));
  print('Index: ${worker.index}, Value: ${worker.value}');

  // Поиск по имени
  workers.sort((a, b) => a.name.compareTo(b.name));
  worker = linearSearch(workers, (w) => w.name.compareTo('Alice'));
  print('Index: ${worker.index}, Value: ${worker.value}');
  worker = linearSearch(workers, (w) => w.name.compareTo('John'));
  print('Index: ${worker.index}, Value: ${worker.value}');
}
