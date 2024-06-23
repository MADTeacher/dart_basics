import 'dart:async';

import 'package:macros/macros.dart';

abstract interface class HelloInterface{
  void hello();
}

macro class Hello implements ClassTypesMacro {

  const Hello();
  @override
  FutureOr<void> buildTypesForClass(
    ClassDeclaration clazz, 
    ClassTypeBuilder builder,
  ) async{
      // путь до библиотеки с интерфейсом
      var iLibrary = Uri.parse(
      'package:macro_function/macro_class.dart',
    );
    var interfaces = NamedTypeAnnotationCode(
        name:await builder.resolveIdentifier(
          iLibrary, 'HelloInterface',
        ),
    );
    // добавляем зависимость класса от интерфейса
    builder.appendInterfaces([interfaces]);
  }
}

macro class Get implements FieldDeclarationsMacro {
  const Get();

  @override
  Future<void> buildDeclarationsForField(
      FieldDeclaration field, MemberDeclarationBuilder builder) async {
        
    final name = field.identifier.name;
    if (!name.startsWith('_')) {
      throw ArgumentError(
          '@Get can only annotate private fields');
    }
    var publicName = name.substring(1);
    var getter = DeclarationCode.fromParts(
        [
          field.type.code, 
          ' get $publicName => ', 
          field.identifier, 
          ';',
        ]);
    builder.declareInType(getter);
  }
}

macro class Set implements FieldDeclarationsMacro {
  const Set();

  @override
  Future<void> buildDeclarationsForField(
      FieldDeclaration field, MemberDeclarationBuilder builder) async {
        
    final name = field.identifier.name;
    if (!name.startsWith('_')) {
      throw ArgumentError(
          '@Set can only annotate private fields');
    }
    var publicName = name.substring(1);

    var print = await builder.resolveIdentifier(
          Uri.parse('dart:core'), 'print',
        );
    var setter = DeclarationCode.fromParts([
      'set $publicName(',
      field.type.code,
      ' val) {\n',
      print,
      "('Setting $publicName to \${val}');\n",
      field.identifier,
      ' = val;\n}',
    ]);
    builder.declareInType(setter);
  }
}