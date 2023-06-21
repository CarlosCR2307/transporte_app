class DealershipModel {
  String? id;
  String? name;
  String? ruc;
  String? email;
  String? status;

  DealershipModel({this.id, this.name, this.ruc, this.email, this.status});

  DealershipModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    ruc = json['ruc'];
    email = json['email'];
    status = json['status'];
    // company =
    //     json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['ruc'] = ruc;
    data['email'] = email;
    data['status'] = status;

    return data;
  }
}
