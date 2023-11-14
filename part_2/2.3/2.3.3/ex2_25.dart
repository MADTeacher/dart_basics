void main() {
  var a = 25, b = 10, c = 17;
  // максимум из трех чисел
  var max = a > b
      ? a > c
          ? a
          : c < b
              ? b
              : c
      : b > c
          ? b
          : c;

  print('Max is $max'); // 25
}
