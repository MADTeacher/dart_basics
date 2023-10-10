String myFunction({
  required String? name,
  required int date,
  required String monthName,
}) {
  if (name != null) {
    return '$name родился $date $monthName!';
  }
  return 'Не установлено имя новорожденного!';
}

void main(List<String> arguments) {
 // OK 
 print(myFunction(
    date: 10,
    monthName: 'сентября',
    name: null,
  ));
  
  // BAD
  // Error: Required named parameter 'name' must be provided.
  print(myFunction(
    date: 10,
    monthName: 'сентября',
  )); 
}
