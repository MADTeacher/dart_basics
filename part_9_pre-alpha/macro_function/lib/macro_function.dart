import 'dart:async';

import 'package:macros/macros.dart';

final _dartCore = Uri.parse('dart:core');

macro class Mul implements FunctionDeclarationsMacro {
  final int scalar;
  const Mul(this.scalar);
  
  @override
  FutureOr<void> buildDeclarationsForFunction(
    FunctionDeclaration function, 
    DeclarationBuilder builder,
  ) async {
    var args = function.positionalParameters;
    var resultType = function.returnType;

    var print = await builder.resolveIdentifier(_dartCore, 'print');
    var code = DeclarationCode.fromParts([
      resultType.code,
      ' mul${function.identifier.name}',
      '(',      
      for (var field in args)
        RawCode.fromParts([
          field.type.code,
          ' ',
          field.identifier,
          ', '
        ]),
      '){\n',
      '\tvar result = ${function.identifier.name}(',
      ...args.map((field) => '${field.identifier.name}, '),
      ');\n',
      '\tresult = result*$scalar; \n\t',
      print,
      "('Result: \${result}');\n",
      '\treturn result;\n',
      '}\n'
    ]);

    builder.declareInLibrary(code);
  }
}

macro class Pow2 implements FunctionDeclarationsMacro {
  const Pow2();
  
  @override
  FutureOr<void> buildDeclarationsForFunction(
    // хранит данные аннотированной функции
    FunctionDeclaration function, 
    // используется для добавления декларации в библиотеку
    DeclarationBuilder builder,
  ) async {
    // получаем все позиционные аргументы
    var args = function.positionalParameters;
    // получаем тип возвращаемого значения декорируемой функции
    var resultType = function.returnType;

    var code = DeclarationCode.fromParts([
      resultType.code,
      ' pow2${function.identifier.name}', // имя добавляемой функции
      '(',      
      for (var field in args) // перечисляем все аргументы
        RawCode.fromParts([
          field.type.code,
          ' ',
          field.identifier,
          ', '
        ]),
      '){\n', // начало тела функции
      // получаем результат декорируемой функции
      '\tvar result = ${function.identifier.name}(',
      ...args.map((field) => '${field.identifier.name}, '),
      ');\n',
      '\treturn result*result;\n', // возвращаем результат
      '}\n' // конец тела функции
    ]);

    // добавляем декларацию в библиотеку
    builder.declareInLibrary(code);
  }
}

macro class MulDef implements FunctionDefinitionMacro {
  const MulDef();
  
  @override
  FutureOr<void> buildDefinitionForFunction(
    FunctionDeclaration function, 
    FunctionDefinitionBuilder builder,
  ) {
    var args = function.positionalParameters;
    builder.augment(FunctionBodyCode.fromParts([
      '{\n',
      '\tvar result = ',
      ...args.map((field) => '${field.identifier.name} *'),
      '1;\n',
      '\treturn result;\n',
      '}',
    ]));
  }
}