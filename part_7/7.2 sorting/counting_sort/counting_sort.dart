extension CountingSort on List<int> {
  void countingSort({bool isAscending = true}) {
    int min = this[0];
    int max = this[0];
    for (int i = 1; i < length; i++) {
      if (this[i] < min) {
        min = this[i];
      }
      if (this[i] > max) {
        max = this[i];
      }
    }

    List<int> count = List<int>.filled(max - min + 1, 0);
    for (var it in this) {
      count[it - min]++;
    }
    if (isAscending) {
      int index = 0;
      for (int i = 0; i < count.length; i++) {
        while (count[i] > 0) {
          this[index++] = i + min;
          count[i]--;
        }
      }
    }else{
      int index = length - 1;
      for (int i = count.length - 1; i >= 0; i--) {
        while (count[i] > 0) {
          this[index--] = i + min;
          count[i]--;
        }
      }
    }
  }
}

void main() {
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.countingSort();
  print(list); // [11, 12, 22, 25, 34, 64, 90]
}
