extension BubbleSort on List<int> {
  void bubbleSort({bool isAscending = true}) {
    for (int i = 0; i < length - 1; i++) {
      for (int j = 0; j < length - i - 1; j++) {
        if (isAscending ? this[j] > this[j + 1] : this[j] < this[j + 1]) {
          int temp = this[j];
          this[j] = this[j + 1];
          this[j + 1] = temp;
        }
      }
    }
  }
}

void main() {
  List<int> list = [64, 34, 25, 12, 22, 11, 90];
  list.bubbleSort();
  print(list);

  list.bubbleSort(isAscending: false);
  print(list);
}
