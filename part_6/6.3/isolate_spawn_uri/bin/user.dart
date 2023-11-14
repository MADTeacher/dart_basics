import 'dart:convert';

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
