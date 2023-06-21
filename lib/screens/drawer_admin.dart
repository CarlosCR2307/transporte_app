import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

import '../models/UserModel.dart';

Future<User> getUser() async {
  User user = User.fromJson(await SessionManager().get("user"));
  return user;
}

class DrawerItem {
  String title;
  IconData icon;
  String router;
  DrawerItem(this.title, this.icon, this.router);
}

class DrawerAdmin {
  static int selectedDrawerIndex = 0;
  late Future<User> userData = getUser();

  static final _drawerItems = [
    DrawerItem("Inicio", Icons.home, '/home'),
    DrawerItem("Inspectores", Icons.person_pin_rounded, '/inspector'),
    DrawerItem("Conductores", Icons.person, '/driver'),
    DrawerItem("Consesionaria", Icons.swap_calls_rounded, '/dealership'),
    DrawerItem("Transportes", Icons.directions_bus, '/transport'),
    DrawerItem("Operativos", Icons.person_3, '/operational'),
    DrawerItem("Reporte", Icons.file_copy, '/report'),
  ];

  static final _drawerItemsInspector = [
    DrawerItem("Inicio", Icons.home, '/home'),
    DrawerItem("Conductores", Icons.person, '/driver'),
    DrawerItem("Consesionaria", Icons.swap_calls_rounded, '/dealership'),
    DrawerItem("Transportes", Icons.directions_bus, '/transport'),
    DrawerItem("Operativos", Icons.person_3, '/operational'),
    DrawerItem("Reporte", Icons.file_copy, '/report'),
  ];

  // static _onTapDrawer(int itemPos, BuildContext context) {
  //   Navigator.pop(context); // cerramos el drawer
  //   selectedDrawerIndex = itemPos;
  // }

  Widget getDrawer(BuildContext context) {
    List<Widget> drawerOptions = [];
    // armamos los items del menu
    for (var i = 0; i < _drawerItems.length; i++) {
      var d = _drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == selectedDrawerIndex,
        onTap: () => {
          Navigator.pop(context),
          selectedDrawerIndex = i,
          Navigator.pushNamed(context, d.router)
        },
      ));
    }

    List<Widget> drawerOptionsInspector = [];
    // armamos los items del menu
    for (var i = 0; i < _drawerItemsInspector.length; i++) {
      var d = _drawerItemsInspector[i];
      drawerOptionsInspector.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == selectedDrawerIndex,
        onTap: () => {
          Navigator.pop(context),
          selectedDrawerIndex = i,
          Navigator.pushNamed(context, d.router)
        },
      ));
    }

    // menu lateral
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.green,
            ), //BoxDecoration
            child: FutureBuilder<User>(
              future: userData,
              initialData: User(),
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
                    return UserAccountsDrawerHeader(
                      decoration: const BoxDecoration(color: Colors.green),
                      accountName: Text(
                        snapshot.data?.name ?? "",
                        style: const TextStyle(fontSize: 18),
                      ),
                      accountEmail: Text(snapshot.data?.rol ?? ""),
                      currentAccountPictureSize: const Size.square(50),
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
          FutureBuilder<User>(
            future: userData,
            initialData: User(),
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
                  if ((snapshot.data?.rol ?? "") == "ADMIN") {
                    return Column(children: drawerOptions);
                  } else {
                    return Column(children: drawerOptionsInspector);
                  }
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ),
        ],
      ),
    );
  }
}
