void main(List<String> arguments) {
  var myStr = 'Hi!';
  for(var i = 0; i <myStr.length; i++){
    print(myStr[i]); // H i !
  }
  myStr.split('').forEach((element) { 
    print(element); // H i !
  });  
}