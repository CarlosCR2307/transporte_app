import 'package:transporte_app/models/DealershipModel.dart';

import '../models/DriverModel.dart';

class TransportArgument {
  final String id;
  final String plateNumber;
  final String soat;
  final String nfc;
  final String idDealership;
  final String idDriver;
  final DriverModel? driver;
  final DealershipModel? dealership;
  final String status;
  final String? idOperational;

  TransportArgument(
      this.id,
      this.plateNumber,
      this.soat,
      this.nfc,
      this.idDealership,
      this.idDriver,
      this.status,
      this.driver,
      this.dealership,
      this.idOperational);
}
