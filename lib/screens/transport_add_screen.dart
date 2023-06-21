import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:transporte_app/models/TransportModel.dart';

import '../models/DealershipModel.dart';
import '../models/DriverModel.dart';
import '../services/dealership_service.dart';
import '../services/driver_service.dart';
import '../services/transport_service.dart';

final DealershipService _serviceDealership = DealershipService();
final DriverService _serviceDriver = DriverService();

Future<List<DriverModel>> getDriver() async {
  Future<List<DriverModel>> listData = _serviceDriver.getDriver('');
  final result = await listData;
  result.add(DriverModel(id: '', name: 'Seleccionar', lastName: ''));
  return result;
}

Future<List<DealershipModel>> getDealership() async {
  Future<List<DealershipModel>> listData = _serviceDealership.getDealership('');
  final result = await listData;
  result.add(DealershipModel(id: '', name: 'Seleccionar'));
  return result;
}

class TransportAddScreen extends StatefulWidget {
  const TransportAddScreen({Key? key}) : super(key: key);

  @override
  State<TransportAddScreen> createState() => _TransportAddState();
}

class _TransportAddState extends State<TransportAddScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final TransportService _inspector = TransportService();
  final TextEditingController plateNumberCtr = TextEditingController();
  final TextEditingController soatCtr = TextEditingController();
  final TextEditingController nfcCtl = TextEditingController();
  final TextEditingController idDealershipCtl = TextEditingController();
  final TextEditingController idDriverCtl = TextEditingController();

  late Future<List<DriverModel>> driverList;
  late Future<List<DealershipModel>> dealershipList;

  late bool isNFC = false;
  ValueNotifier<dynamic> nfcReader = ValueNotifier(null);

  @override
  void initState() {
    idDealershipCtl.text = "";
    idDriverCtl.text = "";
    driverList = getDriver();
    dealershipList = getDealership();
    Future.delayed(Duration.zero, () async {
      isNFC = await NfcManager.instance.isAvailable();
    });
    super.initState();
  }

  // Future<void> getDriver() async {
  //   Future<List<DriverModel>> listData = _serviceDriver.getDriver('');
  //   var data = await listData;
  //   setState(() => driverList.addAll(data));
  // }

  // Future<void> getDealership() async {
  //   Future<List<DealershipModel>> listData =
  //       _serviceDealership.getDealership('');
  //   var data = await listData;
  //   setState(() => dealershipList.addAll(data));
  // }

  Future<void> addTransport() async {
    //get response from ApiClient
    TransportModel newTransport = TransportModel();
    newTransport.plateNumber = plateNumberCtr.text;
    newTransport.soat = soatCtr.text;
    newTransport.nfc = nfcCtl.text;
    newTransport.idDealership = idDealershipCtl.text;
    newTransport.idDriver = idDriverCtl.text;

    if (newTransport.plateNumber == "" ||
        newTransport.soat == "" ||
        newTransport.nfc == "") {
      _messangerKey.currentState!.showSnackBar(SnackBar(
        content: const Text('Completar todos los datos'),
        backgroundColor: Colors.red.shade300,
      ));
    } else {
      dynamic res = await _inspector.addTransport(newTransport);
      if (context.mounted) {
        if (res["status"] == 200) {
          Navigator.pushNamed(context, '/transport');
        } else {
          _messangerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Error: ${res["error"]}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
    }
  }

  // void tagRead() {
  //   if (isNFC) {
  //     _messangerKey.currentState!.showSnackBar(SnackBar(
  //       duration: const Duration(minutes: 2),
  //       content: const Text('Leyendo codigo NFC...'),
  //       backgroundColor: Colors.green.shade300,
  //     ));
  //     NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
  //       nfcReader.value = tag.data;
  //       //if (nfcReader.value) {
  //       Map<String, dynamic> dataRead = jsonDecode(nfcReader.value);
  //       _messangerKey.currentState!.hideCurrentSnackBar();
  //       _messangerKey.currentState!.showSnackBar(SnackBar(
  //         content: Text(dataRead["nfca"]["identifier"].toString()),
  //         backgroundColor: Colors.blue.shade300,
  //       ));
  //       //var data = nfcReader.value["nfca"]["identifier"];
  //       setState(() => nfcCtl.text = dataRead["nfca"]["identifier"]);
  //       //}
  //       NfcManager.instance.stopSession();
  //       _messangerKey.currentState!.hideCurrentSnackBar();
  //     });
  //   } else {
  //     _messangerKey.currentState!.showSnackBar(SnackBar(
  //       content: const Text('Equipo no soporta lector NFC...'),
  //       backgroundColor: Colors.red.shade300,
  //     ));
  //   }
  // }
  void tagRead() {
    try {
      _messangerKey.currentState!.showSnackBar(SnackBar(
        duration: const Duration(minutes: 2),
        content: const Text('Leyendo codigo NFC...'),
        backgroundColor: Colors.green.shade300,
      ));
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        final ndefTag = NfcA.from(tag);
        if (ndefTag != null) {
          final String identifier = ndefTag.identifier
              .map((e) => e.toRadixString(16).padLeft(2, '0'))
              .join('');
          setState(() => nfcCtl.text = identifier);
          _messangerKey.currentState!.hideCurrentSnackBar();
        }
        NfcManager.instance.stopSession();
        //_messangerKey.currentState!.hideCurrentSnackBar();
      });
    } catch (e) {
      _messangerKey.currentState!.hideCurrentSnackBar();
      _messangerKey.currentState!.showSnackBar(SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.blue.shade300,
      ));
      NfcManager.instance.stopSession();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: const Text("Agregar Transporte"),
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
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: plateNumberCtr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Placas",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Placas',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: soatCtr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "SOAT",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'SOAT',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: nfcCtl,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          focusColor: Colors.white,
                          //errorText: "Error",

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.blue, width: 0.5),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.grey,

                          hintText: "NFC",

                          //make hint text
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),

                          //create lable
                          labelText: 'NFC',
                          //lable style
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontFamily: "verdana_regular",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    FutureBuilder<bool>(
                      future: NfcManager.instance.isAvailable(),
                      builder: (context, ss) => ss.data != true
                          ? const ElevatedButton(
                              onPressed: null,
                              child: Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: tagRead,
                              child: const Icon(Icons.nfc),
                            ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Consesionaria",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              FutureBuilder<List<DealershipModel>>(
                future: dealershipList,
                initialData: const [],
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<DealershipModel>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Visibility(
                            visible: snapshot.hasData,
                            child: const Text("Cargando.."))
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        height: 55,
                        child: DropdownButton<String>(
                          value: idDealershipCtl.text,
                          isExpanded: true,
                          items: snapshot.data!.map<DropdownMenuItem<String>>(
                              (DealershipModel value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(
                                value.name ?? "",
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              idDealershipCtl.text = newValue!;
                            });
                          },
                        ),
                      );
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Text("Conductor",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              FutureBuilder<List<DriverModel>>(
                future: driverList,
                initialData: const [],
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<DriverModel>> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        Visibility(
                            visible: snapshot.hasData,
                            child: const Text("Cargando.."))
                      ],
                    );
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return Container(
                        margin: const EdgeInsets.only(
                            bottom: 10, left: 10, right: 10),
                        height: 55,
                        child: DropdownButton<String>(
                          value: idDriverCtl.text,
                          isExpanded: true,
                          items: snapshot.data!.map<DropdownMenuItem<String>>(
                              (DriverModel value) {
                            return DropdownMenuItem<String>(
                              value: value.id,
                              child: Text(
                                '${value.name} ${value.lastName}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              idDriverCtl.text = newValue!;
                            });
                          },
                        ),
                      );
                    } else {
                      return const Text('Empty data');
                    }
                  } else {
                    return Text('State: ${snapshot.connectionState}');
                  }
                },
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
                    onPressed: addTransport,
                    child: const Text('GUARDAR'),
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
