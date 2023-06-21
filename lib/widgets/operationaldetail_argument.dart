import '../models/DealershipModel.dart';
import '../models/DriverModel.dart';
import '../models/TransportModel.dart';

class OperationalDetailArgument {
  final String id;
  final String observation;
  final String nfc;
  final String idTransport;
  final String idInspector;
  final String idDealership;
  final String idDriver;
  final String idOperational;
  final TransportModel? transport;
  final DriverModel? driver;
  final DealershipModel? dealership;
  String? status;

  OperationalDetailArgument(
      this.id,
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
      this.status);
}
