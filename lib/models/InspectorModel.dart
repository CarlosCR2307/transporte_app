class InspectorModel {
  String? id;
  String? name;
  String? lastName;
  String? dni;
  String? address;
  DateTime? birthDate;
  String? gender;
  String? email;
  String? user;
  String? password;
  String? rol;
  String? status;

  InspectorModel(
      {this.id,
      this.name,
      this.lastName,
      this.dni,
      this.address,
      this.birthDate,
      this.gender,
      this.email,
      this.user,
      this.password,
      this.rol,
      this.status});

  InspectorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    dni = json['dni'];
    address = json['address'];
    if (json['birthDate'] != null && json['birthDate'] != "") {
      birthDate = DateTime.parse(json['birthDate']);
    } else {
      birthDate = null;
    }
    gender = json['gender'];
    email = json['email'];
    user = json['user'];
    password = json['password'];
    rol = json['rol'];
    status = json['status'];
    // company =
    //     json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['lastName'] = lastName;
    data['dni'] = dni;
    data['address'] = address;
    data['birthDate'] = birthDate.toString();
    data['gender'] = gender;
    data['email'] = email;
    data['user'] = user;
    data['password'] = password;
    data['rol'] = rol;
    data['status'] = status;

    return data;
  }
}
