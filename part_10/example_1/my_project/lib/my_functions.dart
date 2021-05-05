import 'dart:math';

int add(int a, int b) => a + b + 1;
int sub(int a, int b) => a - b;
int mul(int a, int b) => a * b;
double powN(double a, double n) => pow(a, n).toDouble();

List<String> splitString(String line, String splitter){
  return line.split(splitter);
}

String stringToLowerCase(String line){
  return line.toLowerCase();
}

String stringToUpperCase(String line){
  return line.toUpperCase();
}

String deleteSurroundingSpaces(String line) 
        => line.trim();

