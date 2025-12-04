void myFunction({
  required String name,
  required int date,
  required String monthName,
}) {
  print('$name родился $date $monthName!');
}

void main(List<String> arguments) {
  myFunction(
    date: 10,
    name: 'Александр',
    monthName: 'сентября',
  );
}
