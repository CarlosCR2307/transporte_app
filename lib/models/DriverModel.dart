class DriverModel {
  String? id;
  String? name;
  String? dni;
  String? lastName;
  int? experience;
  String? phone;
  String? driveLicense;
  String? city;
  String? status;

  DriverModel(
      {this.id,
      this.name,
      this.lastName,
      this.dni,
      this.experience,
      this.phone,
      this.driveLicense,
      this.city,
      this.status});

  DriverModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    dni = json['dni'];
    experience = json['experience'];
    phone = json['phone'];
    driveLicense = json['driveLicense'];
    city = json['city'];
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
    data['experience'] = experience;
    data['phone'] = phone;
    data['driveLicense'] = driveLicense;
    data['city'] = city;
    data['status'] = status;

    return data;
  }
}
