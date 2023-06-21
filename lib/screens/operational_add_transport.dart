import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:transporte_app/models/OperationalModel.dart';
import 'package:transporte_app/screens/drawer_admin.dart';

import '../models/DealershipModel.dart';
import '../models/DriverModel.dart';
import '../models/UserModel.dart';
import '../models/operationaldetail_model.dart';
import '../services/operational_service.dart';
import '../widgets/TransportArgument.dart';

class OperationalAddTransportScreen extends StatefulWidget {
  const OperationalAddTransportScreen({Key? key, this.data}) : super(key: key);
  final TransportArgument? data;
  @override
  State<OperationalAddTransportScreen> createState() =>
      _OperationalAddTransportState();
}

class _OperationalAddTransportState
    extends State<OperationalAddTransportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final OperationalService _operational = OperationalService();
  final TextEditingController id = TextEditingController();
  final TextEditingController plateNumberCtr = TextEditingController();
  final TextEditingController soatCtr = TextEditingController();
  final TextEditingController idOperationalCtl = TextEditingController();
  final TextEditingController idTransportCtl = TextEditingController();
  final TextEditingController idDriverCtl = TextEditingController();
  final TextEditingController idDealershipCtl = TextEditingController();
  final TextEditingController nfcCtl = TextEditingController();
  final TextEditingController nameDriverCtl = TextEditingController();
  final TextEditingController dniDriverCtl = TextEditingController();
  final TextEditingController licenseDriverCtl = TextEditingController();
  final TextEditingController observationCtl = TextEditingController();

  @override
  void initState() {
    id.text = widget.data?.id ?? '';
    plateNumberCtr.text = widget.data?.plateNumber ?? '';
    soatCtr.text = widget.data?.soat ?? '';
    idTransportCtl.text = widget.data?.id ?? '';
    idDriverCtl.text = widget.data?.idDriver ?? '';
    nameDriverCtl.text =
        "${(widget.data?.driver?.name ?? '')}  ${(widget.data?.driver?.lastName ?? '')}";
    dniDriverCtl.text = widget.data?.driver?.dni ?? '';
    licenseDriverCtl.text = widget.data?.driver?.driveLicense ?? '';
    idDealershipCtl.text = widget.data?.idDealership ?? '';
    nfcCtl.text = widget.data?.nfc ?? '';
    idOperationalCtl.text = widget.data?.idOperational ?? '';
    super.initState();
  }

  Future<void> addOperationalDetail() async {
    //get response from ApiClient
    User user = User.fromJson(await SessionManager().get("user"));
    OperationaldetailModel newOperationalDetail = OperationaldetailModel();
    newOperationalDetail.observation = observationCtl.text;
    newOperationalDetail.nfc = nfcCtl.text;
    newOperationalDetail.idDriver = idDriverCtl.text;
    newOperationalDetail.idTransport = idTransportCtl.text;
    newOperationalDetail.idDealership = idDealershipCtl.text;
    newOperationalDetail.idInspector = user.id;
    newOperationalDetail.idOperational = idOperationalCtl.text;

    dynamic res = await _operational.addOperationalDetail(newOperationalDetail);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/operational');
      } else {
        _messangerKey.currentState!.showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  void goWeb(String url) {
    Navigator.pushNamed(context, '/viewWeb', arguments: url);
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: const Text("Identificar Transporte"),
          toolbarHeight: 40,
          backgroundColor: const Color.fromARGB(255, 135, 170, 252),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Menu',
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Salir',
              onPressed: () => Navigator.pushNamed(context, '/login'),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SingleChildScrollView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: const Icon(
                  Icons.directions_bus,
                  size: 100.0,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Numero Placa:"),
                    ),
                    Expanded(
                      flex: 3, // takes 70% of available width
                      child: Text(plateNumberCtr.text),
                    ),
                    Expanded(
                      flex: 2, // takes 70% of available width
                      child: ElevatedButton(
                        onPressed: () => {
                          Clipboard.setData(
                              ClipboardData(text: plateNumberCtr.text)),
                          goWeb(
                              "https://portal.mtc.gob.pe/reportedgtt/form/frmconsultaplacaitv.aspx"),
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Codigo SOAT:"),
                    ),
                    Expanded(
                      flex: 3, // takes 70% of available width
                      child: Text(soatCtr.text),
                    ),
                    Expanded(
                      flex: 2, // takes 70% of available width
                      child: ElevatedButton(
                        onPressed: () => {
                          Clipboard.setData(ClipboardData(text: soatCtr.text)),
                          goWeb("https://www.soat.com.pe/servicios-soat/")
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Conductor:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(nameDriverCtl.text),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("DNI Conductor:"),
                    ),
                    Expanded(
                      flex: 3, // takes 70% of available width
                      child: Text(dniDriverCtl.text),
                    ),
                    Expanded(
                      flex: 2, // takes 70% of available width
                      child: ElevatedButton(
                        onPressed: () => {
                          Clipboard.setData(
                              ClipboardData(text: dniDriverCtl.text)),
                          goWeb("https://licencias.mtc.gob.pe/#/index")
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Licencia Conducir:"),
                    ),
                    Expanded(
                      flex: 3, // takes 70% of available width
                      child: Text(licenseDriverCtl.text),
                    ),
                    Expanded(
                      flex: 2, // takes 70% of available width
                      child: ElevatedButton(
                        onPressed: () => {
                          Clipboard.setData(
                              ClipboardData(text: licenseDriverCtl.text)),
                          goWeb(
                              "https://www.gob.pe/358-consultar-los-datos-de-un-vehiculo-consulta-vehicular"),
                        },
                        child: const Icon(Icons.link),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
                  margin: const EdgeInsets.all(5.0),
                  child: const Text(
                    "Observaciones:",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 5, bottom: 5, right: 10),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: TextField(
                  controller: observationCtl,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Observaciones'),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 226, 94),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: addOperationalDetail,
                    child: const Text('REGISTRAR'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
