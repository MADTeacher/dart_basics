String myFunction(
   String name = 'Александр', 
   int date, 
   String monthName,
){
  return '$name родился $date $monthName!';
}

String myFunction(
  String name, [
  int date=10, 
  String monthName,
]){
  return '$name родился $date $monthName!';
}
