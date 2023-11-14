import 'dart:convert';
import 'dart:io';

import 'package:protocol/protocol.dart';
import 'package:http_server/http_server.dart';

final _encoder = JsonEncoder.withIndent('  ');

Future<GetAllUsersResponse> getAllUsers(UserDB db) async {
  return GetAllUsersResponse(await db.getAll());
}

Future<OperationResponse> addUser(UserDB db, User user) async {
  try {
    await db.add(user);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<OperationResponse> updateUser(UserDB db, User user) async {
  try {
    await db.update(user);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<OperationResponse> deleteUser(UserDB db, int id) async {
  try {
    await db.delete(id);
    return OperationResponse(true);
  } catch (e) {
    return OperationResponse(false);
  }
}

Future<GetUserResponse> getUser(UserDB db, int id) async {
  try {
    return GetUserResponse(await db.getById(id));
  } catch (e) {
    return GetUserResponse(null);
  }
}

void getHandlers(HttpRequest request, UserDB userDB) async {
  var response = request.response;
  if (request.uri.path.startsWith('/user') && request.uri.query != '') {
    var id = int.parse(request.uri.queryParameters['id']!);
    response
      ..headers.contentType = ContentType(
        'application',
        'json',
      )
      ..write(_encoder.convert(await getUser(userDB, id)))
      ..close();
    return;
  } 
  if (request.uri.path.startsWith('/allUsers')) {
    response
      ..headers.contentType = ContentType(
        'application',
        'json',
      )
      ..write(_encoder.convert(await getAllUsers(userDB)))
      ..close();
    return;
  }
}

void postHandlers(HttpRequest request, UserDB userDB) async {
  final response = request.response;
  try {
    final body = await utf8.decoder.bind(request).join();
    if (request.uri.path.startsWith('/addUser')) {
      final message = AddUserRequest.fromJson(jsonDecode(body));
      await addUser(userDB, message.user);
    } else if (request.uri.path.startsWith('/updateUser')) {
      final message = UpdateUserRequest.fromJson(jsonDecode(body));
      await updateUser(userDB, message.user);
    } else {
      throw ArgumentError('User add or update error');
    }
    response
      ..headers.contentType = ContentType(
        'application',
        'json',
      )
      ..write(_encoder.convert(OperationResponse(true)))
      ..close();
  } catch (e) {
    response
      ..headers.contentType = ContentType(
        'application',
        'json',
      )
      ..statusCode = HttpStatus.badRequest
      ..write(_encoder.convert(OperationResponse(false)))
      ..close();
  }
}

void postPositionHandlers(HttpRequest request, UserDB userDB) async {
  final response = request.response;
  final part = request.requestedUri.pathSegments;
  try {
    if (part[0] == 'deleteUser') {
      var id = int.tryParse(part.last);
      await deleteUser(userDB, id!);
      response
        ..headers.contentType = ContentType(
          'application',
          'json',
        )
        ..write(_encoder.convert(OperationResponse(true)))
        ..close();
    } else {
      throw ArgumentError('User delete error');
    }
  } catch (e) {
    print(e);
    response
      ..headers.contentType = ContentType(
        'application',
        'json',
      )
      ..statusCode = HttpStatus.badRequest
      ..write(_encoder.convert(OperationResponse(false)))
      ..close();
  }
}

void main(List<String> arguments) async {
  var userDB = UserDB('bin\\users.json');
  await userDB.init();
  HttpServer? httpServer;
  print('Запуск main');
  HttpServer.bind(InternetAddress.loopbackIPv4, 8080).then((server) {
    httpServer = server;
    server.listen((HttpRequest request) async {
      try {
        ContentType? contentType = request.headers.contentType;
        switch ((request.method, contentType?.mimeType)) {
          case ('GET', _):
            getHandlers(request, userDB);
          case ('POST', 'application/json'):
            postHandlers(request, userDB);
          case ('POST', _):
            postPositionHandlers(request, userDB);
          default:
            request.response
              ..statusCode = HttpStatus.methodNotAllowed
              ..write('Unsupported request: ${request.method}.')
              ..close();
        }
      } catch (e) {
        print('Exception in handleRequest: $e');
      }
    });
  });

  stdin.transform(utf8.decoder).listen((data) {
    if (data == 'exit') {
      httpServer?.close();
    }
    exit(0);
  });
  print('Завершение main');
}
