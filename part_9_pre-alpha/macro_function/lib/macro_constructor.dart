import 'dart:async';

import 'package:macros/macros.dart';

macro class DefaultConstructor implements ClassDeclarationsMacro {
  const DefaultConstructor();

  @override
  FutureOr<void> buildDeclarationsForClass(
            ClassDeclaration clazz, 
            MemberDeclarationBuilder builder,
   ) async {
    // получаем поля класса
    var fields = await builder.fieldsOf(clazz);
    var code = DeclarationCode.fromParts([
      clazz.identifier.name, // имя класса
      '(',      
      ...fields.map((field) => 'this.${field.identifier.name},'),
      ');'
    ]);
    // добавляем конструктор в класс
    builder.declareInType(code);
  }
}