void main() {
  var i = 13;
  while (i > 0) {
    i--;
    if (i % 2 == 0) {
      continue;
    }
    print(i); // 11  9  7  5  3  1
  }
}
