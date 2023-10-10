import 'dart:math';


final bb = 10;
double add(double a, double b) => _add(a, b);
double sub(double a, double b) => a - b;
double div(double a, double b) => a / b;
double mul(double a, double b) => a * b;
double pow2(double a) => a * a;
double powN(double a, double n) => pow(a, n).toDouble();

double _add(double a, double b){
  return (a + b) * 10;
}
