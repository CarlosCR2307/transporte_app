import 'package:flutter/material.dart';
import 'package:transporte_app/screens/drawer_admin.dart';

import '../widgets/InspectorArgument.dart';

class InspectorViewScreen extends StatefulWidget {
  const InspectorViewScreen({Key? key}) : super(key: key);

  @override
  State<InspectorViewScreen> createState() => _InspectorViewState();
}

class _InspectorViewState extends State<InspectorViewScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    InspectorArgument args =
        ModalRoute.of(context)!.settings.arguments as InspectorArgument;

    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: const Text("Información Conductor"),
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
                padding: const EdgeInsets.only(top: 10, bottom: 25),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: const Icon(
                  Icons.person_pin_rounded,
                  size: 100.0,
                  color: Colors.grey,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Nombre:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.name),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Apellido:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.lastName),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("DNI:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.dni),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Direccion:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.address),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Fecha Nacimiento:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.birthDate.substring(0, 10)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Sexo:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.gender),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Correo:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.email),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Usuario:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.user),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Contraseña:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.password),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                margin: const EdgeInsets.all(5.0),
                //decoration: BoxDecoration(border: Border.all()),
                child: Row(
                  children: [
                    const Expanded(
                      flex: 5, // takes 30% of available width
                      child: Text("Rol:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.rol),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
