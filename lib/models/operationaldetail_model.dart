import 'dart:ffi';

import 'package:transporte_app/models/InspectorModel.dart';

import 'DealershipModel.dart';
import 'DriverModel.dart';
import 'TransportModel.dart';

class OperationaldetailModel {
  String? id;
  String? observation;
  String? nfc;
  String? idTransport;
  String? idInspector;
  String? idDealership;
  String? idDriver;
  String? idOperational;
  TransportModel? transport;
  DriverModel? driver;
  DealershipModel? dealership;
  String? status;

  OperationaldetailModel(
      {this.id,
      this.observation,
      this.nfc,
      this.idTransport,
      this.idInspector,
      this.idDealership,
      this.idDriver,
      this.idOperational,
      this.transport,
      this.driver,
      this.dealership,
      this.status});

  OperationaldetailModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    observation = json['observation'];
    nfc = json['nfc'];
    idTransport = json['idTransport'];
    idInspector = json['idInspector'];
    idDealership = json['idDealership'];
    idDriver = json['idDriver'];
    idOperational = json['idOperational'];
    status = json['status'];
    if (json["transport"] != null) {
      transport = TransportModel.fromJson(json["transport"]);
    }
    if (json["dealership"] != null) {
      dealership = DealershipModel.fromJson(json["dealership"]);
    }
    if (json["driver"] != null) {
      driver = DriverModel.fromJson(json["driver"]);
    }
    // company =
    //     json['company'] != null ? new Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['observation'] = observation;
    data['nfc'] = nfc;
    data['idTransport'] = idTransport;
    data['idInspector'] = idInspector;
    data['idDealership'] = idDealership;
    data['idDriver'] = idDriver;
    data['idOperational'] = idOperational;
    data['status'] = status;

    return data;
  }
}
