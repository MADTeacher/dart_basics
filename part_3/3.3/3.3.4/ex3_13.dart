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

void main(List<String> arguments) {
  var myAdd = add;
  print(myAdd(10, 5)); // 15

  var mySeason = season;
  print(mySeason(10)); // Autumn
  print(mySeason(-1)); // WTF? (╯'□')╯︵ ┻━┻

  var o_O = (int a, int b){
    return a * b;
  };
  print(o_O(10, 5)); // 50
}
