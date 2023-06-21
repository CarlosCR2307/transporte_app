import 'package:flutter/material.dart';
import 'package:transporte_app/models/DriverModel.dart';
import 'package:transporte_app/services/driver_service.dart';

import '../widgets/DriverArgument.dart';
import 'drawer_admin.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({Key? key}) : super(key: key);

  @override
  State<DriverScreen> createState() => _DriverState();
}

class _DriverState extends State<DriverScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late List<DriverModel> driverList = [];
  final DriverService _service = DriverService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    Future<List<DriverModel>> listData =
        _service.getDriver(searchController.text);
    var data = await listData;
    setState(() => {driverList = data});
  }

  Future<void> removeDriver(String id) async {
    dynamic res = await _service.removeDriver(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/driver');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> editDriver(String id) async {
    dynamic res = await _service.getDriverById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/driverEdit',
            arguments: DriverArgument(
              res["data"]["_id"],
              res["data"]["name"],
              res["data"]["lastName"],
              res["data"]["dni"],
              res["data"]["experience"],
              res["data"]["phone"],
              res["data"]["driveLicense"],
              res["data"]["city"],
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

  Future<void> viewDriver(String id) async {
    dynamic res = await _service.getDriverById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/driverView',
            arguments: DriverArgument(
              res["data"]["_id"],
              res["data"]["name"],
              res["data"]["lastName"],
              res["data"]["dni"],
              res["data"]["experience"],
              res["data"]["phone"],
              res["data"]["driveLicense"],
              res["data"]["city"],
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
    Future<List<DriverModel>> listData =
        _service.getDriver(searchController.text);
    var data = await listData;
    setState(() => {driverList = data});
  }

  @override
  Widget build(BuildContext context) {
    //var widthScreen = MediaQuery.of(context).size.width;
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        drawer: DrawerAdmin().getDrawer(context),
        appBar: AppBar(
          title: const Text("Conductores"),
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
            Navigator.pushNamed(context, '/driverAdd');
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
                itemCount: driverList.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                        '${driverList[index].name ?? ""} ${driverList[index].lastName ?? ""}'),
                    subtitle: Text(driverList[index].dni ?? ""),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text('EDITAR ${driverList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    editDriver(driverList[index].id ?? ""),
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
                                  'Eliminar Conductor ${driverList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    removeDriver(driverList[index].id ?? ""),
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
                        title: Text('VER ${driverList[index].name}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {
                              viewDriver(driverList[index].id ?? ""),
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
