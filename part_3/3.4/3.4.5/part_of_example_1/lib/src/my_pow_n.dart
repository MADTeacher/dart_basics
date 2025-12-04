part of 'calculator.dart';

import 'dart:math';
/* Если import 'dart:math' подсвечивается как ошибка, 
значит в Dart SDK еще перевели функциональность enhanced-parts, 
как в используемую по умолчанию. 

Просто переместите этот импорт в файл 'calculator.dart',
установив его до первого упоминания part. Например:
import 'dart:math';

part 'my_mul.dart';
part 'my_pow_n.dart';
*/

double _powN(double a, double n) => pow(a, n).toDouble();