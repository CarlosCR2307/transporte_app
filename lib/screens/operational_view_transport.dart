import 'package:flutter/material.dart';
import '../widgets/operationaldetail_argument.dart';

class OperationalViewTransportScreen extends StatefulWidget {
  const OperationalViewTransportScreen({Key? key, this.data}) : super(key: key);
  final OperationalDetailArgument? data;
  @override
  State<OperationalViewTransportScreen> createState() =>
      _OperationalViewTransportState();
}

class _OperationalViewTransportState
    extends State<OperationalViewTransportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
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
    plateNumberCtr.text = widget.data?.transport?.plateNumber ?? '';
    soatCtr.text = widget.data?.transport?.soat ?? '';
    idTransportCtl.text = widget.data?.id ?? '';
    idDriverCtl.text = widget.data?.idDriver ?? '';
    nameDriverCtl.text =
        "${(widget.data?.driver?.name ?? '')}  ${(widget.data?.driver?.lastName ?? '')}";
    dniDriverCtl.text = widget.data?.driver?.dni ?? '';
    licenseDriverCtl.text = widget.data?.driver?.driveLicense ?? '';
    idDealershipCtl.text = widget.data?.idDealership ?? '';
    nfcCtl.text = widget.data?.nfc ?? '';
    idOperationalCtl.text = widget.data?.idOperational ?? '';
    observationCtl.text = widget.data?.observation ?? "";
    super.initState();
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
          title: const Text("Transporte Identificado"),
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
                      flex: 5, // takes 70% of available width
                      child: Text(plateNumberCtr.text),
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
                      flex: 5, // takes 70% of available width
                      child: Text(soatCtr.text),
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
                      flex: 5, // takes 70% of available width
                      child: Text(dniDriverCtl.text),
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
                      flex: 5, // takes 70% of available width
                      child: Text(licenseDriverCtl.text),
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
                      child: Text("Observaciones:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(observationCtl.text),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
