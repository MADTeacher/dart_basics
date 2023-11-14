String myFunction({
  String? name,
  required int date,
  required String monthName,
}) {
  if (name != null) {
    return '$name родился $date $monthName!';
  }
  return 'Не установлено имя новорожденного!';
}

void main(List<String> arguments) {
  print(myFunction(
    date: 10,
    monthName: 'сентября',
  ));
  print(myFunction(
    date: 10,
    monthName: 'сентября',
    name: 'Иван',
  ));
}
