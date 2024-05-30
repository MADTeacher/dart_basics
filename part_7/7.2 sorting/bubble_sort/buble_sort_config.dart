extension BubbleSort<T> on List<T> {
  void bubbleSort(bool Function(T, T) compare) {
    for (int i = 0; i < length - 1; i++) {
      for (int j = 0; j < length - i - 1; j++) {
        if (compare(this[j], this[j + 1]))  {
          T temp = this[j];
          this[j] = this[j + 1];
          this[j + 1] = temp;
        }
      }
    }
  }
}

class Worker {
  final String name;
  final int id;

  Worker(this.name, this.id);

  @override
  String toString() => 'Worker(name: $name, id: $id)';
}

void main() {
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.bubbleSort((a,b) => a < b);
  print(list);

  list.bubbleSort((a,b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.bubbleSort((a, b) => a.id > b.id);
  print(workers);

  workers.bubbleSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
