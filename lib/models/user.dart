class User {
  const User({this.id, this.email, this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"] as String?,
      email: json["email"] as String?,
      name: json["name"] as String?,
    );
  }

  final String? id;
  final String? email;
  final String? name;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{"id": id, "email": email, "name": name};
  }
}
