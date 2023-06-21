import 'package:flutter/material.dart';
import 'package:transporte_app/screens/drawer_admin.dart';

import '../widgets/InspectorArgument.dart';
import '../widgets/TransportArgument.dart';

class TransportViewScreen extends StatefulWidget {
  const TransportViewScreen({Key? key}) : super(key: key);

  @override
  State<TransportViewScreen> createState() => _TransportViewState();
}

class _TransportViewState extends State<TransportViewScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    TransportArgument args =
        ModalRoute.of(context)!.settings.arguments as TransportArgument;

    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: const Text("Información Transporte"),
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
                  Icons.directions_bus,
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
                      child: Text("Placas:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.plateNumber),
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
                      child: Text("SOAT:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.soat),
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
                      child: Text("NFC:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.nfc),
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
                      child: Text("Conductor:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(
                          "${(args.driver?.name ?? '')} ${(args.driver?.lastName ?? '')}"),
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
                      child: Text("Consesionaria:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text((args.dealership?.name ?? '')),
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
