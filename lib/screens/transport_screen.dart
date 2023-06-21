import 'package:flutter/material.dart';
import 'package:transporte_app/models/DealershipModel.dart';
import 'package:transporte_app/models/DriverModel.dart';
import 'package:transporte_app/models/TransportModel.dart';
import '../services/transport_service.dart';
import '../widgets/TransportArgument.dart';
import 'drawer_admin.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({Key? key}) : super(key: key);

  @override
  State<TransportScreen> createState() => _TransportState();
}

class _TransportState extends State<TransportScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController searchController = TextEditingController();
  late List<TransportModel> transportList = [];
  final TransportService _service = TransportService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    Future<List<TransportModel>> listData =
        _service.getTransport(searchController.text);
    var data = await listData;
    setState(() => {transportList = data});
  }

  Future<void> removeTransport(String id) async {
    dynamic res = await _service.removeTransport(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/transport');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> editTransport(String id) async {
    dynamic res = await _service.getTransportById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/transportEdit',
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
                ''));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> viewTransport(String id) async {
    dynamic res = await _service.getTransportById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/transportView',
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
                ''));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  void search(String s) async {
    Future<List<TransportModel>> listData =
        _service.getTransport(searchController.text);
    var data = await listData;
    setState(() => {transportList = data});
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
        drawer: DrawerAdmin().getDrawer(context),
        appBar: AppBar(
          title: const Text("Transportes"),
          toolbarHeight: 40,
          backgroundColor: const Color.fromARGB(255, 135, 170, 252),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'Menu',
            onPressed: () => scaffoldKey.currentState!.openDrawer(),
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/transportAdd');
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: TextField(
                  controller: searchController,
                  onChanged: search,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    )),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    hintText: 'Buscar',
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: ((context, index) => const Divider()),
                reverse: false,
                scrollDirection: Axis.vertical,
                itemCount: transportList.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.directions_bus),
                    title: Text(
                        "${(transportList[index].plateNumber ?? "")} - ${(transportList[index].soat ?? "")}"),
                    subtitle: Text(
                        "${(transportList[index].driver?.name ?? "")} ${(transportList[index].driver?.lastName ?? "")}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                  'EDITAR ${transportList[index].plateNumber}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    editTransport(
                                        transportList[index].id ?? ""),
                                    Navigator.pop(context, 'OK')
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Eliminar',
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(
                                  'Eliminar Transporte ${transportList[index].plateNumber}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    viewTransport(
                                        transportList[index].id ?? ""),
                                    Navigator.pop(context, 'OK')
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('VER ${transportList[index].plateNumber}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {
                              viewTransport(transportList[index].id ?? ""),
                              Navigator.pop(context, 'OK')
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    // onLongPress: () => showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => AlertDialog(
                    //     title: Text(
                    //         'Eliminar Transporte ${transportList[index].plateNumber}'),
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'Cancel'),
                    //         child: const Text('Cancel'),
                    //       ),
                    //       TextButton(
                    //         onPressed: () => {
                    //           removeTransport(transportList[index].id ?? ""),
                    //           Navigator.pop(context, 'OK')
                    //         },
                    //         child: const Icon(
                    //           Icons.delete,
                    //           color: Colors.red,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
