import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:ffi/ffi.dart' as ffi;

import 'package:ffi_stack/ffi_stack.dart';

void main(List<String> arguments) {
  var nativeLibrary = DynamicLibrary.open(path.join(
    Directory.current.path,
    'bin',
    'lib_stack.dll',
  ));
  var nativeStackLib = NativeStack(nativeLibrary);

  // создание экземпляра стека, через вызов функции
  // динамической библиотеки
  final stack = nativeStackLib.createStack();
  print(nativeStackLib.isEmpty(stack).isOdd); // true

  nativeStackLib.push(stack, 42);
  print(nativeStackLib.isEmpty(stack).isOdd); // false

  nativeStackLib.push(stack, -6);
  nativeStackLib.push(stack, 7);
  nativeStackLib.push(stack, 22);
  nativeStackLib.push(stack, 412);

  while (!nativeStackLib.isEmpty(stack).isOdd) {
    print('Pop stack: ${nativeStackLib.pop(stack)}');
  }
  nativeStackLib.deleteStack(stack);
  
  print("*"*15);
  
  // создание экземпляра стека из Dart-кода.
  // Такой способ можно использовать, когда 
  // размер выделяемой памяти выводится
  // во время компиляции
  var newStack = ffi.malloc<Stack>();
  nativeStackLib.push(newStack, -6);
  nativeStackLib.push(newStack, 7);
  nativeStackLib.push(newStack, 22);
  nativeStackLib.push(newStack, 412);
  while (!nativeStackLib.isEmpty(newStack).isOdd) {
    print('Pop newStack: ${nativeStackLib.pop(newStack)}');
  }
  ffi.malloc.free(newStack);
}
