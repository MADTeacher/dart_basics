int add(int a, int b) {
  return a + b;
}

String season(int month) {
  return switch (month) {
    == 12 || > 0 && < 3 => 'Winter',
    >= 3 && < 6 => 'Spring',
    >= 6 && < 9 => 'Summer',
    >= 9 && < 12 => 'Autumn',
    _ => "WTF? (╯'□')╯︵ ┻━┻",
  };
}

String myStrFunc(
  String prefix,
  int month,
  String Function(int) func,
) {
  return prefix + ' ' + func(month);
}

int sub(
  int a,
  int b, {
  int c = 10,
  int Function(int, int) func = add,
}) {
  return c - func(a, b);
}

void main(List<String> arguments) {
  print(myStrFunc('ヽ༼ ಥ_ಥ༽ﾉ', 12, season)); 
  // ヽ༼ ಥ_ಥ༽ﾉ Winter
  print(myStrFunc("(҂ 'з´) ︻╦̵̵̿╤──", 0, season));
  // (҂ 'з´) ︻╦̵̵̿╤── WTF? (╯'□')╯︵ ┻━┻

  print(sub(3, 7)); // 0
  print(sub(2, 4, c: 2)); // -4
  print(sub(2, 4, c: 2, func: (int a, int b) {
    return a * b;
  })); // -6
}
