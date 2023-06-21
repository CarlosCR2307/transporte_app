class User {
  String? id;
  String? name;
  String? rol;

  User({this.id, this.name, this.rol});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rol = json['rol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = <String, dynamic>{};
    user["id"] = id;
    user["name"] = name;
    user["rol"] = rol;
    return user;
  }
}
