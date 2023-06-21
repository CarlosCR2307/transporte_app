import 'package:flutter/material.dart';
import '../widgets/DealershipArgument.dart';

class DealershipViewScreen extends StatefulWidget {
  const DealershipViewScreen({Key? key}) : super(key: key);

  @override
  State<DealershipViewScreen> createState() => _DealershipViewState();
}

class _DealershipViewState extends State<DealershipViewScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    DealershipArgument args =
        ModalRoute.of(context)!.settings.arguments as DealershipArgument;
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: const Text("Información Consesionaria"),
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
                  Icons.swap_calls_rounded,
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
                      child: Text("RUC:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.ruc),
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
            ],
          ),
        ),
      ),
    );
  }
}
