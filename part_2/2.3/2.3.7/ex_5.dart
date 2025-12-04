void main() {
  var a = 10;
  var b = switch (a) {
    2 => 5 + a,
    3 => 4 + a,
    _ => 10 - a, // значение по умолчанию
  };

  print(b); // 0
}
