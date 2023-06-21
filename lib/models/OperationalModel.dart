import 'dart:ffi';

import 'package:transporte_app/models/InspectorModel.dart';

class OperationalModel {
  String? id;
  String? name;
  String? date;
  String? time;
  Double? latitud;
  Double? longitude;
  String? ubication;
  String? idInspector;
  InspectorModel? inspector;
  String? status;

  OperationalModel(
      {this.id,
      this.name,
      this.date,
      this.time,
      this.latitud,
      this.longitude,
      this.ubication,
      this.idInspector,
      this.inspector,
      this.status});

  OperationalModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    time = json['time'];
    latitud = json['latitud'];
    longitude = json['longitude'];
    ubication = json['ubication'];
    idInspector = json['idInspector'];
    status = json['status'];
    if (json["inspector"] != null) {
      inspector = InspectorModel.fromJson(json["inspector"]);
    }
    // company =
    //     json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['date'] = date;
    data['time'] = time;
    data['latitud'] = latitud;
    data['longitude'] = longitude;
    data['ubication'] = ubication;
    data['idInspector'] = idInspector;
    data['status'] = status;

    return data;
  }
}
