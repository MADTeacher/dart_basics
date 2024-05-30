extension MergeSort<T> on List<T> {
  void mergeSort(bool Function(T, T) compare) {
    if (isEmpty) {
      throw StateError('List is empty');
    }
    List<T?> buffer = List.filled(
      length,
      null,
      growable: true,
    );
    _mergeSort(buffer, 0, length - 1, compare);
  }

  void _mergeSort(
    List<T?> buffer,
    int left,
    int right,
    bool Function(T, T) compare,
  ) {
    if (left < right) {
      int mid = (left + right) ~/ 2;
      _mergeSort(buffer, left, mid, compare);
      _mergeSort(buffer, mid + 1, right, compare);

      var (k, i) = (left, left);
      var j = mid + 1;

      while (i <= mid && j <= right) {
        if (j > right || (i <= mid && compare(this[i], this[j]))) {
          buffer[k++] = this[i++];
        } else {
          buffer[k++] = this[j++];
        }
      }
      
      // Копирование элементов с левой стороны, если они остались
      while (i <= mid) {
        buffer[k++] = this[i++];
      }

      // Копирование элементов с правой стороны, если они остались
      while (j <= right) {
        buffer[k++] = this[j++];
      }

      for (var it = left; it <= right; it++) {
        this[it] = buffer[it]!;
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
  list.mergeSort((a, b) => a < b);
  print(list);

  list.mergeSort((a, b) => a > b);
  print(list);

  List<Worker> workers = [
    Worker('Bob', 11),
    Worker('Alice', 2),
    Worker('Charlie', 3),
    Worker('David', 4),
    Worker('Eve', 52),
    Worker('Frank', 16),
  ];
  workers.mergeSort((a, b) => a.id > b.id);
  print(workers);

  workers.mergeSort((a, b) => a.name.compareTo(b.name) < 0);
  print(workers);
}
