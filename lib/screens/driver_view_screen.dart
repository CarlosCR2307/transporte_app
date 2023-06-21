import 'package:flutter/material.dart';
import 'package:transporte_app/widgets/DriverArgument.dart';

import '../services/driver_service.dart';

class DriverViewScreen extends StatefulWidget {
  const DriverViewScreen({Key? key}) : super(key: key);

  @override
  State<DriverViewScreen> createState() => _DriverViewState();
}

class _DriverViewState extends State<DriverViewScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController id = TextEditingController();
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController lastNameCtr = TextEditingController();
  final TextEditingController dniCtl = TextEditingController();
  final TextEditingController experienceCtl = TextEditingController();
  final TextEditingController phoneCtl = TextEditingController();
  final TextEditingController driveLicenseCtl = TextEditingController();
  final TextEditingController cityCtl = TextEditingController();
  final TextEditingController statusCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;
    DriverArgument args =
        ModalRoute.of(context)!.settings.arguments as DriverArgument;
    setState(() {
      id.text = args.id;
      nameCtr.text = args.name;
      lastNameCtr.text = args.lastName;
      dniCtl.text = args.dni;
      experienceCtl.text = args.experience.toString();
      phoneCtl.text = args.phone;
      driveLicenseCtl.text = args.driveLicense;
      cityCtl.text = args.city;
      statusCtl.text = args.status;
    });

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
                  Icons.person,
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
                      child: Text("Años Experiencia:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.experience.toString()),
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
                      child: Text("Telefono:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.phone),
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
                      child: Text("Licencia Conducir:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.driveLicense),
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
                      child: Text("Ciudad:"),
                    ),
                    Expanded(
                      flex: 5, // takes 70% of available width
                      child: Text(args.city),
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
