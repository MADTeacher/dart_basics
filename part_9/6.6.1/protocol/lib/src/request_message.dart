import 'user.dart';

////////////RequestType//////////
enum RequestType {
  all,
  add,
  update,
  delete,
  get;

  static RequestType fromString(String value) {
    try {
      return RequestType.values.firstWhere(
        (element) => element.toString().split('.').last == value,
      );
    } catch (_) {
      throw FormatException('Invalid enum value: $value');
    }
  }
}

////////////RequestMessage//////////
sealed class RequestMessage {
  final RequestType type;

  RequestMessage({required this.type});

  factory RequestMessage.fromJson(Map<String, dynamic> json) {
    switch (RequestType.fromString(json['type'])) {
      case RequestType.all:
        return GetAllUsersRequest();
      case RequestType.add:
        return AddUserRequest.fromJson(json);
      case RequestType.update:
        return UpdateUserRequest.fromJson(json);
      case RequestType.delete:
        return DeleteUserRequest.fromJson(json);
      case RequestType.get:
        return GetUserRequest.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

class GetAllUsersRequest extends RequestMessage {
  GetAllUsersRequest({super.type = RequestType.all});

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
    };
  }
}

class AddUserRequest extends RequestMessage {
  final User user;
  AddUserRequest(this.user, {super.type = RequestType.add});

  factory AddUserRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return AddUserRequest(User.fromJson(json['user']));
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'user': user.toJson(),
    };
  }
}

class UpdateUserRequest extends RequestMessage {
  final User user;

  UpdateUserRequest(
    this.user, {
    super.type = RequestType.update,
  });

  factory UpdateUserRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return UpdateUserRequest(
      User.fromJson(json['user']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'user': user.toJson(),
    };
  }
}

class DeleteUserRequest extends RequestMessage {
  final int id;

  DeleteUserRequest(
    this.id, {
    super.type = RequestType.delete,
  });

  factory DeleteUserRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return DeleteUserRequest(json['id']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'id': id,
    };
  }
}

class GetUserRequest extends RequestMessage {
  final int id;

  GetUserRequest(
    this.id, {
    super.type = RequestType.get,
  });

  factory GetUserRequest.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetUserRequest(json['id']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'id': id,
    };
  }
}
