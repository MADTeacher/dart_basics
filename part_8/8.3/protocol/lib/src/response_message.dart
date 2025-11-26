import 'user.dart';

////////////ResponseType//////////
enum ResponseType {
  all,
  success,
  get;

  static ResponseType fromString(String value) {
    try {
      return ResponseType.values.firstWhere(
        (element) => element.toString().split('.').last == value,
      );
    } catch (_) {
      throw FormatException('Invalid enum value: $value');
    }
  }
}

////////////ResponseMessage//////////
sealed class ResponseMessage {
  final ResponseType type;

  ResponseMessage({required this.type});
  factory ResponseMessage.fromJson(Map<String, dynamic> json) {
    switch (ResponseType.fromString(json['type'])) {
      case ResponseType.all:
        return GetAllUsersResponse.fromJson(json);
      case ResponseType.get:
        return GetUserResponse.fromJson(json);
      case ResponseType.success:
        return OperationResponse.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

class GetAllUsersResponse extends ResponseMessage {
  final List<User> users;

  GetAllUsersResponse(
    this.users, {
    super.type = ResponseType.all,
  });

  factory GetAllUsersResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final usersResponse = json['users'] as List<dynamic>;
    if (usersResponse.isNotEmpty) {
      return GetAllUsersResponse(
        usersResponse.map((e) => User.fromJson(e)).toList(),
      );
    }
    return GetAllUsersResponse([]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'users': users.map((e) => e.toJson()).toList(),
    };
  }
}

class GetUserResponse extends ResponseMessage {
  final User? user;

  GetUserResponse(
    this.user, {
    super.type = ResponseType.get,
  });

  factory GetUserResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    if (json['user'] != null) {
      return GetUserResponse(User.fromJson(json['user']));
    }
    return GetUserResponse(null);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'user': user?.toJson(),
    };
  }
}

class OperationResponse extends ResponseMessage {
  final bool success;
  OperationResponse(
    this.success, {
    super.type = ResponseType.success,
  });

  factory OperationResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return OperationResponse(json['success']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'success': success,
    };
  }
}