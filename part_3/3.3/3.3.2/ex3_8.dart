String myFunction(
  String name, [
  int? date = 10,
  String monthName = 'июля',
]) {
  return '$name родился $date $monthName!';
}

void main(List<String> arguments) {
  print(myFunction('Александр'));
  print(myFunction('Александр', 24));
  print(myFunction('Александр', 20, 'мая'));
}
