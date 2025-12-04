import 'dart:async';

void main(){
  runZoned((){
    print('Hello Zone: ${Zone.current}');
    print('(⊙ _ ⊙ )');
  }, zoneSpecification: ZoneSpecification(
    print: (Zone self, ZoneDelegate parent, Zone zone, String line){
     // self - зона, на которую был зарегистрирован обработчик
     // parent - родительская зона self
     // zone - текущая зона, для которой родительской выступает self
     // line - строка, которая была передана в Zone.print
      parent.print(zone, '${DateTime.now()} [$self] $line');
    }
  ));
}
