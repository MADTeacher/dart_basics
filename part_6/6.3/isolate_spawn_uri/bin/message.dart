import 'dart:isolate';
import 'user.dart';

enum MessageType {
  start,
  stop,
  userRequest,
  userResponse;

  static MessageType fromString(String value) {
    return switch (value) {
      'start' => MessageType.start,
      'userRequest' => MessageType.userRequest,
      'userResponse' => MessageType.userResponse,
      'stop' => MessageType.stop,
      _ => throw Exception('Unknown message type: $value'),
    };
  }
}

sealed class Message {
  final MessageType type;
  Message({required this.type});

  factory Message.fromJson(Map<String, dynamic> json) {
    if (json case {'type': var type}) {
      var msType = MessageType.fromString(type);
      return switch (msType) {
        MessageType.start => StartMessage.fromJson(json),
        MessageType.stop => StopMessage.fromJson(json),
        MessageType.userRequest => UserRequestMessage.fromJson(
            json,
          ),
        MessageType.userResponse => UserResponseMessage.fromJson(
            json,
          ),
      };
    }

    throw Exception('Unknown message: $json');
  }

  Map<String, dynamic> toJson();
}

class StartMessage extends Message {
  final SendPort sender;
  StartMessage(
    this.sender, {
    super.type = MessageType.start,
  });

  factory StartMessage.fromJson(Map<String, dynamic> json) {
    return StartMessage(json['sender']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'type': type.name, 'sender': sender};
  }
}

class StopMessage extends Message {
  StopMessage({super.type = MessageType.stop});

  factory StopMessage.fromJson(Map<String, dynamic> json) {
    return StopMessage();
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
    };
  }
}

class UserRequestMessage extends Message {
  final int id;
  UserRequestMessage(
    this.id, {
    super.type = MessageType.userRequest,
  });

  factory UserRequestMessage.fromJson(Map<String, dynamic> json) {
    return UserRequestMessage(json['userId']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'userId': id,
    };
  }
}

class UserResponseMessage extends Message {
  final User? user;
  UserResponseMessage(
    this.user, {
    super.type = MessageType.userResponse,
  });

  factory UserResponseMessage.fromJson(Map<String, dynamic> json) {
    if (json case {'type': 'userResponse', 'user': var user}) {
      if (user is Map<String, dynamic>) {
        return UserResponseMessage(User.fromJson(user));
      }
    }
    return UserResponseMessage(null);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'user': user?.toJson(),
    };
  }
}
