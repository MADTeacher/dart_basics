import 'dart:convert';
import 'dart:math';
import 'dart:isolate';

class User {
  final UserData data;
  final Support support;

  User({required this.data, required this.support});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      data: UserData.fromJson(json['data']),
      support: Support.fromJson(json['support']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data.toJson(), 'support': support.toJson()};
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

  Support({required this.url, required this.text});

  factory Support.fromJson(Map<String, dynamic> json) {
    return Support(url: json['url'], text: json['text']);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'text': text};
  }
}

Future<User?> fetchUser(int id) async {
  if (id > 20) {
    return null;
  }

  // Генератор случайных чисел
  final random = Random();

  // Списки с данными для генерации
  final firstNames = ['John', 'Jane', 'Alex', 'Emily', 'Chris'];
  final lastNames = ['Doe', 'Smith', 'Johnson', 'Williams', 'Brown'];
  final avatars = [
    'https://ex.in/img/faces/1-image.jpg',
    'https:// ex.in/img/faces/2-image.jpg',
    'https:// ex.in/img/faces/3-image.jpg',
    'https:// ex.in/img/faces/4-image.jpg',
    'https:// ex.in/img/faces/5-image.jpg',
  ];
  final supportUrls = [
    'https:// ex.in/#support-heading',
    'https://example.com/support',
  ];
  final supportTexts = [
    'To keep ReqRes free, contributions are appreciated!',
    'Example support text.',
  ];

  // Имитация задержки, чтобы симулировать сетевой запрос
  await Future.delayed(Duration(milliseconds: 500));

  // Генерация случайных данных
  final firstName = firstNames[random.nextInt(firstNames.length)];
  final lastName = lastNames[random.nextInt(lastNames.length)];
  final email =
      '${firstName.toLowerCase()}.${lastName.toLowerCase()}'
      '@example.com';
  final avatar = avatars[random.nextInt(avatars.length)];
  final supportUrl = supportUrls[random.nextInt(supportUrls.length)];
  final supportText = supportTexts[random.nextInt(supportTexts.length)];

  // Создание объекта User с сгенерированными данными
  final user = User(
    data: UserData(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      avatar: avatar,
    ),
    support: Support(url: supportUrl, text: supportText),
  );

  return user;
}

Future<User?> fetchUserWithoutId() async {
  return await fetchUser(1);
}

void main() async {
  print('Запуск main');
  // запуск изолята с передачей функции, требующей указание
  // аргумента и которая будет выполняться в новом изоляте
  Isolate.run<User?>(() => fetchUser(2)).then((value) => print(value));
  // или
  // var user = await Isolate.run<User?>(
  //   () => fetchUser(2),
  // );

  // запуск изолята с указанием функции без входных аргументов,
  // которая будет выполняться в новом изоляте
  Isolate.run<User?>(fetchUserWithoutId).then((value) => print(value));
  print('завершение main');
}
