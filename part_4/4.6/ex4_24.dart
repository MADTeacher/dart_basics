extension MyInt on int {
  int mul2() {
    return this<<1;
  }

  bool isSetBit(int bit) {
    return (this & (1 << bit)) != 0;
  } 
}

void main(List<String> arguments) {
  var value = 11;
  print(value.mul2()); // 22
  print(value.isSetBit(2)); // false
  print(value.isSetBit(0)); // true
}
