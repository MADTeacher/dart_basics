String myFunction(String name){
  var hello = 'Привет, $name!';
  return hello;
}

void main(List<String> arguments) {
  var myHelloString = myFunction('Александр');   
  print(myHelloString); // <-  Привет, Александр!
}
