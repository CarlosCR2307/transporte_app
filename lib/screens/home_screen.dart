import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:transporte_app/screens/drawer_admin.dart';

import '../models/UserModel.dart';

Future<User> getUser() async {
  User user = User.fromJson(await SessionManager().get("user"));
  return user;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Future<User> u;

  @override
  void initState() {
    u = getUser();
    super.initState();
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 40,
            ),
            const Center(
              child: Text(
                "Hola, Bienvenido",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Center(
              child: FutureBuilder<User>(
                future: u,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<User> snapshot,
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
                      return SizedBox(
                        height: 30,
                        child: Text(
                          snapshot.data?.name ?? "",
                          style: const TextStyle(fontSize: 15),
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
            ),
            const SizedBox(
              height: 40,
            ),
            IconButton(
              icon: const Icon(
                Icons.directions_bus,
                size: 25,
              ),
              tooltip: 'Increase volume by 10',
              onPressed: () {
                Navigator.pushNamed(context, '/operational');
              },
            ),
            const Text('Ver Operativos', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
