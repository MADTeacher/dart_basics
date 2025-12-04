class Caffee {
  final String name;
  final String address;
  final int? yearOpened;

  Caffee({
    required this.name,
    required this.address,
    this.yearOpened,
  });

  factory Caffee.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    if (name is! String) {
      throw FormatException(
        'Required "name" field of type String in $json',
      );
    }

    final address = json['address'];
    if (address is! String) {
      throw FormatException(
        'Required "address" field of type String in $json',
      );
    }

    final yearOpened = json['yearOpened'] as int?;
    // аналогично
    // final yearOpened = json['yearOpened'];
    // if (yearOpened is! int?) {
    //   throw FormatException(
    //     'Required "address" field of type int? in $json',
    //   );
    // }
    return Caffee(
      name: name,
      address: address,
      yearOpened: yearOpened,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'yearOpened': yearOpened,
      };

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write('Caffee{name: $name, address: $address, ');
    sb.write('yearOpened: $yearOpened}');
    return sb.toString();
  }
}

void main() {
  final json1 = {
    'name': 'Rome',
    'address': 'Italy, Rome',
    'yearOpened': 1500,
  };

  final json2 = {
    'name': 'xXx',
    'address': 'Mexico, Mexico City',
  };

  print(Caffee.fromJson(json1));
  print(Caffee.fromJson(json2));
}
