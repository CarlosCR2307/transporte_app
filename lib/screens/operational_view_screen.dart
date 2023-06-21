import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:transporte_app/models/TransportModel.dart';

import '../models/DealershipModel.dart';
import '../models/DriverModel.dart';
import '../models/operationaldetail_model.dart';
import '../services/operational_service.dart';
import '../services/transport_service.dart';
import '../widgets/OperationalArgument.dart';
import '../widgets/TransportArgument.dart';
import '../widgets/operationaldetail_argument.dart';

// final OperationalService _serviceOperational = OperationalService();

// Future<List<OperationaldetailModel>> getDetails(id) async {
//   Future<List<OperationaldetailModel>> listData =
//       _serviceOperational.getOperationalDetail(id);
//   final result = await listData;
//   return result;
// }

class OperationalViewScreen extends StatefulWidget {
  const OperationalViewScreen({Key? key, this.data}) : super(key: key);
  final OperationalArgument? data;

  @override
  State<OperationalViewScreen> createState() => _OperationalViewState();
}

class _OperationalViewState extends State<OperationalViewScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final OperationalService _service = OperationalService();
  final TransportService _serviceTransport = TransportService();
  final TextEditingController id = TextEditingController();
  late List<OperationaldetailModel> operationalDetailList = [];

  @override
  void initState() {
    id.text = widget.data?.id ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
    super.initState();
  }

  Future<void> _getData() async {
    Future<List<OperationaldetailModel>> listData =
        _service.getOperationalDetail(id.text);
    var data = await listData;
    setState(() => {operationalDetailList = data});
  }

  Future<void> addTransportOperational() async {
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

          _messangerKey.currentState!.hideCurrentSnackBar();

          dynamic res = await _serviceTransport.getTransportByNFC(identifier);
          if (context.mounted) {
            if (res["status"] == 200) {
              Navigator.pushNamed(context, '/operationalTransportAdd',
                  arguments: TransportArgument(
                      res["data"]["id"],
                      res["data"]["plateNumber"],
                      res["data"]["soat"],
                      res["data"]["nfc"],
                      res["data"]["idDealership"] ?? '',
                      res["data"]["idDriver"] ?? '',
                      res["data"]["status"],
                      DriverModel.fromJson(res["data"]["driver"] ?? ''),
                      DealershipModel.fromJson(res["data"]["dealership"] ?? ''),
                      id.text));
            } else {
              _messangerKey.currentState!.showSnackBar(SnackBar(
                content: Text('Error: ${res["error"]}'),
                backgroundColor: Colors.red.shade300,
              ));
            }
          }
        }
        NfcManager.instance.stopSession();
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

  // Future<void> addTransportOperational2() async {
  //   try {
  //     dynamic res = await _serviceTransport.getTransportByNFC("5383c5a4600001");
  //     if (context.mounted) {
  //       if (res["status"] == 200) {
  //         Navigator.pushNamed(context, '/operationalTransportAdd',
  //             arguments: TransportArgument(
  //                 res["data"]["id"],
  //                 res["data"]["plateNumber"],
  //                 res["data"]["soat"],
  //                 res["data"]["nfc"],
  //                 res["data"]["idDealership"] ?? '',
  //                 res["data"]["idDriver"] ?? '',
  //                 res["data"]["status"],
  //                 DriverModel.fromJson(res["data"]["driver"] ?? ''),
  //                 DealershipModel.fromJson(res["data"]["dealership"] ?? ''),
  //                 id.text));
  //       } else {
  //         _messangerKey.currentState!.showSnackBar(SnackBar(
  //           content: Text('Error: ${res["error"]}'),
  //           backgroundColor: Colors.red.shade300,
  //         ));
  //       }
  //     }
  //   } catch (e) {}
  // }

  Future<void> viewOperationalDetail(String id) async {
    dynamic res = await _service.getOperationalDetailById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(
          context,
          '/operationalTransportView',
          arguments: OperationalDetailArgument(
              res["data"]["id"],
              res["data"]["observation"],
              res["data"]["nfc"],
              res["data"]["idTransport"] ?? '',
              res["data"]["idInspector"] ?? '',
              res["data"]["idDealership"] ?? '',
              res["data"]["idDriver"] ?? '',
              res["data"]["idOperational"] ?? '',
              TransportModel.fromJson(res["data"]["transport"] ?? ''),
              DriverModel.fromJson(res["data"]["driver"] ?? ''),
              DealershipModel.fromJson(res["data"]["dealership"] ?? ''),
              res["data"]["status"]),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    OperationalArgument args =
        ModalRoute.of(context)!.settings.arguments as OperationalArgument;

    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: Text(args.name),
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
        floatingActionButton: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? const FloatingActionButton(
                  //onPressed: () => addTransportOperational2(),
                  onPressed: null,
                  backgroundColor: Colors.red,
                  child: Icon(Icons.remove),
                )
              : FloatingActionButton(
                  onPressed: () => addTransportOperational(),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.nfc),
                ),
        ),
        body: SingleChildScrollView(
          //crossAxisAlignment: CrossAxisAlignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: const Text(
                  "Transportes Identificados",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: ((context, index) => const Divider()),
                reverse: false,
                scrollDirection: Axis.vertical,
                itemCount: operationalDetailList.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(
                        (operationalDetailList[index].transport?.plateNumber ??
                            "")),
                    subtitle: Text(
                        "${(operationalDetailList[index].driver?.name ?? "")} ${(operationalDetailList[index].driver?.lastName ?? "")}"),
                    onTap: () => viewOperationalDetail(
                        operationalDetailList[index].id ?? ""),
                    onLongPress: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            'Eliminar Transporte ${operationalDetailList[index].id}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {Navigator.pop(context, 'OK')},
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
