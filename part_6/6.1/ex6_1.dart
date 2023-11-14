import 'dart:async';

void main(List<String> arguments) {
  Future(() => print('1-й элемент очереди событий'));
  Future(() => print('2-й элемент очереди событий'));
  
  Future.microtask((){
    print('1-й элемент очереди микрозадач');
    });
  scheduleMicrotask((){
    print('2-й элемент очереди микрозадач');
    });
} 
