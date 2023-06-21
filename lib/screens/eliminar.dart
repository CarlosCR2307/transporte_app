import 'package:flutter/material.dart';
import 'package:transporte_app/screens/drawer_admin.dart';

import '../models/InspectorModel.dart';
import '../models/OperationalModel.dart';
import '../services/operational_service.dart';
import '../widgets/OperationalArgument.dart';

class ManagerScreen extends StatefulWidget {
  const ManagerScreen({Key? key}) : super(key: key);

  @override
  State<ManagerScreen> createState() => _ManagerState();
}

class _ManagerState extends State<ManagerScreen> {
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
                    hintText: 'Buscar',
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
                    leading: const Icon(Icons.person),
                    title: Text((operationalList[index].name ?? "")),
                    subtitle:
                        Text(operationalList[index].inspector?.name ?? ""),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar',
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text('EDITAR ${operationalList[index].name}'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
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
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('VER ${operationalList[index].name}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {
                              viewOperational(operationalList[index].id ?? ""),
                              Navigator.pop(context, 'OK')
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                    onLongPress: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            'Eliminar Operativo ${operationalList[index].name}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
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
