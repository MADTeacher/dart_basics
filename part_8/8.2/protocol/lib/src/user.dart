class User{
  final int id;
  final String name;
  final int age;
  final String education;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.education
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      education: json['education']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'education': education
  };

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    sb.write('User{id: $id, name: $name, ');
    sb.write('age: $age, education: $education}');
    return sb.toString();
  }
}