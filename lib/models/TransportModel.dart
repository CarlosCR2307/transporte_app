import 'package:transporte_app/models/DealershipModel.dart';

import 'DriverModel.dart';

class TransportModel {
  String? id;
  String? plateNumber;
  String? soat;
  String? nfc;
  String? idDealership;
  String? idDriver;
  String? status;
  DriverModel? driver;
  DealershipModel? dealership;

  TransportModel(
      {this.id,
      this.plateNumber,
      this.soat,
      this.nfc,
      this.idDealership,
      this.idDriver,
      this.driver,
      this.dealership,
      this.status});

  TransportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    plateNumber = json['plateNumber'];
    soat = json['soat'];
    nfc = json['nfc'];
    idDealership = json['idDealership'];
    idDriver = json['idDriver'];
    status = json['status'];
    if (json["driver"] != null) {
      driver = DriverModel.fromJson(json["driver"]);
    }
    if (json["dealership"] != null) {
      dealership = DealershipModel.fromJson(json["dealership"]);
    }
    // company =
    //     json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['plateNumber'] = plateNumber;
    data['soat'] = soat;
    data['nfc'] = nfc;
    data['idDealership'] = idDealership;
    data['idDriver'] = idDriver;
    data['status'] = status;

    return data;
  }
}
