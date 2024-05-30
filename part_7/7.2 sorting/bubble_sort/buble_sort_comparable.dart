extension BubbleSort<T extends Comparable> on List<T> {
  void bubbleSort({bool isAscending = true}) {
    for (int i = 0; i < length - 1; i++) {
      for (int j = 0; j < length - i - 1; j++) {
        if (isAscending
            ? this[j].compareTo(this[j + 1]) > 0
            : this[j].compareTo(this[j + 1]) < 0) {
          T temp = this[j];
          this[j] = this[j + 1];
          this[j + 1] = temp;
        }
      }
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
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.bubbleSort();
  print(list);

  list.bubbleSort(isAscending: false);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.bubbleSort();
  print(workers);

  workers.bubbleSort(isAscending: false);
  print(workers);
}
