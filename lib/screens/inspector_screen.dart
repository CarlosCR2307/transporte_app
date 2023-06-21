import 'package:flutter/material.dart';
import 'package:transporte_app/models/InspectorModel.dart';
import 'package:transporte_app/screens/drawer_admin.dart';
import 'package:transporte_app/services/inspector_service.dart';

import '../widgets/InspectorArgument.dart';

class InspectorScreen extends StatefulWidget {
  const InspectorScreen({Key? key}) : super(key: key);

  @override
  State<InspectorScreen> createState() => _InspectorState();
}

class _InspectorState extends State<InspectorScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late List<InspectorModel> inspectorList = [];
  final InspectorService _service = InspectorService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    Future<List<InspectorModel>> listData =
        _service.getInspector(searchController.text);
    var data = await listData;
    setState(() => {inspectorList = data});
  }

  Future<void> removeInspector(String id) async {
    dynamic res = await _service.removeInspector(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/inspector');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> editInspector(String id) async {
    dynamic res = await _service.getInspectorById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/inspectorEdit',
            arguments: InspectorArgument(
              res["data"]["_id"],
              res["data"]["name"],
              res["data"]["lastName"],
              res["data"]["dni"],
              res["data"]["address"],
              res["data"]["birthDate"],
              res["data"]["gender"],
              res["data"]["email"] ?? '',
              res["data"]["user"],
              res["data"]["password"],
              res["data"]["rol"],
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

  Future<void> viewInspector(String id) async {
    dynamic res = await _service.getInspectorById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/inspectorView',
            arguments: InspectorArgument(
              res["data"]["_id"],
              res["data"]["name"],
              res["data"]["lastName"],
              res["data"]["dni"],
              res["data"]["address"],
              res["data"]["birthDate"],
              res["data"]["gender"],
              res["data"]["email"] ?? '',
              res["data"]["user"],
              res["data"]["password"],
              res["data"]["rol"],
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
    Future<List<InspectorModel>> listData =
        _service.getInspector(searchController.text);
    var data = await listData;
    setState(() => {inspectorList = data});
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
          title: const Text("Inspectores"),
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
            Navigator.pushNamed(context, '/inspectorAdd');
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
                itemCount: inspectorList.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.person_pin_rounded),
                    title: Text(
                        '${inspectorList[index].name ?? ""} ${inspectorList[index].lastName ?? ""}'),
                    subtitle: Text(inspectorList[index].dni ?? ""),
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
                                  Text('EDITAR ${inspectorList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    editInspector(
                                        inspectorList[index].id ?? ""),
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
                                  'Eliminar Inspector ${inspectorList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    removeInspector(
                                        inspectorList[index].id ?? ""),
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
                        title: Text('VER ${inspectorList[index].name}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {
                              viewInspector(inspectorList[index].id ?? ""),
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
