void main() {
  int? a;
  int? b = 1;
  int c = 10;

  var tt = [?a, ?b, c];
  print(tt); // [1, 10]
}
