import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

class User {
  final UserData data;
  final Support support;

  User({
    required this.data,
    required this.support,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      data: UserData.fromJson(json['data']),
      support: Support.fromJson(json['support']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'support': support.toJson(),
    };
  }

  @override
  String toString() {
    return JsonEncoder.withIndent('  ').convert(this);
  }
}

class UserData {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  UserData({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'avatar': avatar,
    };
  }
}

class Support {
  final String url;
  final String text;

  Support({
    required this.url,
    required this.text,
  });

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(
      url: json['url'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'text': text,
    };
  }
}

/// сообщения между главным и создаваемым изолятом
sealed class Message {}

class StartMessage extends Message {
  final SendPort sender;
  StartMessage(this.sender);
}

class StopMessage extends Message {}

class UserRequestMessage extends Message {
  final int id;
  UserRequestMessage(this.id);
}

class UserResponseMessage extends Message {
  final User? user;
  UserResponseMessage(this.user);
}

void isolateFetchUser(StartMessage message) async {
  var receivePort = ReceivePort();
  var sendPort = message.sender;
  sendPort.send(
    StartMessage(receivePort.sendPort),
  );

  receivePort.listen((message) async {
    switch (message) {
      case StopMessage():
        sendPort.send(StopMessage());
        receivePort.close();
        Isolate.current.kill();
      case UserRequestMessage(id: var id):
        var user = await fetchUser(id);
        sendPort.send(UserResponseMessage(user));
    }
  });
}

void main() async {
  var receivePort = ReceivePort();
  await Isolate.spawn(
    isolateFetchUser,
    StartMessage(receivePort.sendPort),
  );

  SendPort? sendPort;

  receivePort.listen((message) {
    switch (message) {
      case StartMessage(sender: var port):
        sendPort = port;
      case StopMessage():
        print('Isolate stopped');
        // receivePort.close();
      case UserResponseMessage(user: var user):
        print(user);
    }
  });

  await Future.delayed(Duration(seconds: 1));

  while (true) {
    if (sendPort == null) {
      print('Isolate not started');
      break;
    }

    print('Enter user id');
    var input = stdin.readLineSync()!;
    var id = int.tryParse(input);
    if (id is int) {
      sendPort?.send(UserRequestMessage(id));
    } else if (input == 'exit') {
      sendPort?.send(StopMessage());
      break;
    } else {
      print('Invalid user id');
    }
    await Future.delayed(Duration(seconds: 1));
  }
}

Future<User?> fetchUser(int id) async {
  User? user;
  var httpClient = HttpClient();
  try {
    var request = await httpClient.getUrl(
      Uri.parse('https://reqres.in/api/users/$id'),
    );
    var response = await request.close();
    if (response.statusCode == HttpStatus.ok) {
      var responseBody = await response.transform(utf8.decoder).join();
      user = User.fromJson(jsonDecode(responseBody));
    }
  } catch (e) {
    print('An error occurred during the API call: $e');
  } finally {
    httpClient.close();
  }
  return user;
}
