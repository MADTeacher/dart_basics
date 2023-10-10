void myFunction(
  String name,
  int date,
  String monthName,
  int salary,
  String workPosition,
) {
  print('$name родился $date $monthName!');
  print('$name заработал $salary рублей в месяц.');
  print('$name работает в должности $workPosition.');
}

void main(List<String> arguments) {
  myFunction(
    'Александр',
    10,
    'сентября',
    10000,
    'бухгалтер',
  );
}
