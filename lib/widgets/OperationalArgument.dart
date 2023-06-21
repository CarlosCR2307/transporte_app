import 'package:transporte_app/models/InspectorModel.dart';

class OperationalArgument {
  final String id;
  final String name;
  final String date;
  final String time;
  final String latitud;
  final String longitude;
  final String ubication;
  final String idInspector;
  final InspectorModel? inspector;
  final String status;

  OperationalArgument(
      this.id,
      this.name,
      this.date,
      this.time,
      this.latitud,
      this.longitude,
      this.ubication,
      this.idInspector,
      this.inspector,
      this.status);
}
