import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:transporte_app/models/DealershipModel.dart';
import 'package:transporte_app/models/DriverModel.dart';
import 'package:transporte_app/models/InspectorModel.dart';
import 'package:transporte_app/models/OperationalModel.dart';
import 'package:transporte_app/screens/drawer_admin.dart';
import 'package:transporte_app/services/operational_service.dart';
import 'package:transporte_app/widgets/OperationalArgument.dart';

import '../models/UserModel.dart';
import '../widgets/TransportArgument.dart';

class OperationalScreen extends StatefulWidget {
  const OperationalScreen({Key? key}) : super(key: key);

  @override
  State<OperationalScreen> createState() => _OperationalState();
}

class _OperationalState extends State<OperationalScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late List<OperationalModel> operationalList = [];
  final OperationalService _service = OperationalService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    User user = User.fromJson(await SessionManager().get("user"));
    Future<List<OperationalModel>> listData =
        _service.getOperational(searchController.text);
    var data = await listData;
    setState(() => {operationalList = data});
  }

  Future<void> removeOperational(String id) async {
    dynamic res = await _service.removeOperational(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/operational');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> editOperational(String id) async {
    dynamic res = await _service.getOperationalById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/operationalEdit',
            arguments: OperationalArgument(
              res["data"]["id"],
              res["data"]["name"],
              res["data"]["date"],
              res["data"]["time"],
              res["data"]["latitud"] ?? '',
              res["data"]["longitude"] ?? '',
              res["data"]["ubication"] ?? '',
              res["data"]["idInspector"] ?? '',
              InspectorModel.fromJson(res["data"]["inspector"] ?? ''),
              res["data"]["status"],
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> viewOperational(String id) async {
    dynamic res = await _service.getOperationalById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/operationalView',
            arguments: OperationalArgument(
              res["data"]["id"],
              res["data"]["name"],
              res["data"]["date"],
              res["data"]["time"],
              res["data"]["latitud"] ?? '',
              res["data"]["longitude"] ?? '',
              res["data"]["ubication"] ?? '',
              res["data"]["idInspector"] ?? '',
              InspectorModel.fromJson(res["data"]["inspector"] ?? ''),
              res["data"]["status"],
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  void search(String s) async {
    User user = User.fromJson(await SessionManager().get("user"));
    Future<List<OperationalModel>> listData = _service.getOperational(s);
    var data = await listData;
    setState(() => {operationalList = data});
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        drawer: DrawerAdmin().getDrawer(context),
        appBar: AppBar(
          title: const Text("Operativos"),
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
            Navigator.pushNamed(context, '/operationalAdd');
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
                    hintText: 'Buscar por ubicacion',
                  ),
                ),
              ),
              ListView.separated(
                shrinkWrap: true,
                separatorBuilder: ((context, index) => const Divider()),
                reverse: false,
                scrollDirection: Axis.vertical,
                itemCount: operationalList.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.person_3),
                    title: Text(
                        "${(operationalList[index].name ?? "")} - ${(operationalList[index].ubication ?? "")}"),
                    subtitle:
                        Text(operationalList[index].inspector?.name ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title:
                                  Text('EDITAR ${operationalList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    editOperational(
                                        operationalList[index].id ?? ""),
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
                                  'Eliminar Transporte ${operationalList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    removeOperational(
                                        operationalList[index].id ?? ""),
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
                    onTap: () =>
                        viewOperational(operationalList[index].id ?? ""),
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
