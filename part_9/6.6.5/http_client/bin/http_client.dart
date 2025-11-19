import 'dart:convert';
import 'dart:io';

import 'package:protocol/protocol.dart';

int getId() {
  print('Введите введите id');
  var id = int.parse(stdin.readLineSync()!);
  return id;
}

User addUser() {
  print('Введите введите id');
  var id = int.parse(stdin.readLineSync()!);
  print('Введите введите имя');
  var name = stdin.readLineSync()!;
  print('Введите введите возраст');
  var age = int.parse(stdin.readLineSync()!);
  print('Введите введите образование');
  var education = stdin.readLineSync()!;
  return User(
    id: id,
    name: name,
    age: age,
    education: education,
  );
}

Future<void> getAllUsers(HttpClient httpClient) async {
  try {
    var request = await httpClient.getUrl(
      Uri.parse('http://127.0.0.1:8080/allUsers'),
    );
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response
          .transform(
            utf8.decoder,
          )
          .join();
      print(responseBody);
    }
  } catch (e) {
    print('An error occurred during the API call: $e');
  }
}

Future<void> getUser(HttpClient httpClient, int id) async {
  try {
    var request = await httpClient.getUrl(
      Uri.parse('http://127.0.0.1:8080/user?id=$id'),
    );
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var responseBody = await response
          .transform(
            utf8.decoder,
          )
          .join();
      print(responseBody);
    }
  } catch (e) {
    print('An error occurred during the API call: $e');
  }
}

Future<void> deleteUser(HttpClient httpClient, int id) async {
  try {
    var request = await httpClient.postUrl(
      Uri.parse('http://127.0.0.1:8080/deleteUser/$id'),
    );
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var responseBody = await response
          .transform(
            utf8.decoder,
          )
          .join();
      print(responseBody);
    }
  } catch (e) {
    print('An error occurred during the API call: $e');
  }
}

Future<void> addOrUpdateUser(
  HttpClient httpClient,
  User user, [
  String endpoint = 'updateUser',
]) async {
  try {
    var request = await httpClient.postUrl(
      Uri.parse('http://127.0.0.1:8080/$endpoint'),
    );

    RequestMessage? requestMessage;
    if (endpoint == 'updateUser') {
      requestMessage = UpdateUserRequest(user);
    } else {
      requestMessage = AddUserRequest(user);
    }

    request
      ..headers.contentType = ContentType(
        'application',
        'json',
      )
      ..write(jsonEncode(requestMessage));
    final response = await request.close();
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.badRequest) {
      var responseBody = await response
          .transform(
            utf8.decoder,
          )
          .join();
      print(responseBody);
    }
  } catch (e) {
    print('An error occurred during the API call: $e');
  }
}

void main(List<String> arguments) async {
  while (true) {
    print('*' * 20);
    print('1. GetAllUsers');
    print('2. AddUser');
    print('3. UpdateUser');
    print('4. DeleteUser');
    print('5. GetUser');
    print('6. Exit');
    print('*' * 20);
    final httpClient = HttpClient();
    var input = stdin.readLineSync();
    if (input is String) {
      switch (input) {
        case '1':
          await getAllUsers(httpClient);
        case '2':
          var user = addUser();
          await addOrUpdateUser(httpClient, user, 'addUser');
        case '3':
          var user = addUser();
          await addOrUpdateUser(httpClient, user);
        case '4':
          var id = getId();
          await deleteUser(httpClient, id);
        case '5':
          var id = getId();
          await getUser(httpClient, id);
        case '6':
          // закрываем соединение и освобождаем ресурсы
          httpClient.close();
          return;
        default:
          print('Некорректный ввод');
      }
    }
    httpClient.close();
    await Future.delayed(const Duration(seconds: 2));
  }
}
