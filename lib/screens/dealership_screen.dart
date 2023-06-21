import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:transporte_app/models/DealershipModel.dart';
import 'package:transporte_app/screens/drawer_admin.dart';
import 'package:transporte_app/services/dealership_service.dart';

import '../models/UserModel.dart';
import '../widgets/DealershipArgument.dart';

Future<User> getUser() async {
  User user = User.fromJson(await SessionManager().get("user"));
  return user;
}

class DealershipScreen extends StatefulWidget {
  const DealershipScreen({Key? key}) : super(key: key);

  @override
  State<DealershipScreen> createState() => _DealershipState();
}

class _DealershipState extends State<DealershipScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController searchController = TextEditingController();
  late List<DealershipModel> dealershipList = [];
  final DealershipService _service = DealershipService();
  late Future<User> u;
  @override
  void initState() {
    super.initState();
    u = getUser();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getData();
    });
  }

  Future<void> _getData() async {
    Future<List<DealershipModel>> listData =
        _service.getDealership(searchController.text);
    var data = await listData;
    setState(() => {dealershipList = data});
  }

  Future<void> removeDealership(String id) async {
    dynamic res = await _service.removeDealership(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/dealership');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res["error"]}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  Future<void> editDealership(String id) async {
    dynamic res = await _service.getDealershipById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/dealershipEdit',
            arguments: DealershipArgument(
              res["data"]["_id"],
              res["data"]["name"],
              res["data"]["ruc"],
              res["data"]["email"],
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

  Future<void> viewDealership(String id) async {
    dynamic res = await _service.getDealershipById(id);
    if (context.mounted) {
      if (res["status"] == 200) {
        Navigator.pushNamed(context, '/dealershipView',
            arguments: DealershipArgument(
              res["data"]["_id"],
              res["data"]["name"],
              res["data"]["ruc"],
              res["data"]["email"],
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
    Future<List<DealershipModel>> listData =
        _service.getDealership(searchController.text);
    var data = await listData;
    setState(() => {dealershipList = data});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        drawer: DrawerAdmin().getDrawer(context),
        appBar: AppBar(
          title: const Text("Consesionarias"),
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
            Navigator.pushNamed(context, '/dealershipAdd');
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
                itemCount: dealershipList.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.swap_calls_rounded),
                    title: Text((dealershipList[index].name ?? "")),
                    subtitle: Text(dealershipList[index].ruc ?? ""),
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
                                  Text('EDITAR ${dealershipList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    editDealership(
                                        dealershipList[index].id ?? ""),
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
                                  'Eliminar Consesionaria ${dealershipList[index].name}'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => {
                                    removeDealership(
                                        dealershipList[index].id ?? ""),
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
                        title: Text('VER ${dealershipList[index].name}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => {
                              viewDealership(dealershipList[index].id ?? ""),
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
