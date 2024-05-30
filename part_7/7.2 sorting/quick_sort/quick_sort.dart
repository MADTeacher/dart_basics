extension QuickSort<T> on List<T> {
  void quickSort(bool Function(T, T) compare) {
    if (isEmpty){
      return;
    }
    _quickSort(0, length - 1, compare);
  }

  void _quickSort(int left, int right, bool Function(T, T) compare) {
    if (left < right) {
      int pivot = _partition(left, right, compare);
      _quickSort(left, pivot - 1, compare);
      _quickSort(pivot + 1, right, compare);
    }
  }

  void swap(int i, int j) {
    T temp = this[i];
    this[i] = this[j];
    this[j] = temp;
  }

  int _partition(int left, int right, bool Function(T, T) compare) {
    T pivot = this[right];
    int less = left;

    for (int i = left; i < right; i++) {
      if (compare(this[i], pivot)) {
        swap(i, less);
        less++;
      }
    }
    swap(less, right);
    return less;
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
  list.quickSort((a,b) => a < b);
  print(list);

  list.quickSort((a,b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.quickSort((a, b) => a.id > b.id);
  print(workers);

  workers.quickSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}