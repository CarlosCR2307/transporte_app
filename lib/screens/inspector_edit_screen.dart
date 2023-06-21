import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transporte_app/models/InspectorModel.dart';
import 'package:transporte_app/widgets/InspectorArgument.dart';

import '../services/inspector_service.dart';

class InspectorEditScreen extends StatefulWidget {
  const InspectorEditScreen({Key? key, this.data}) : super(key: key);
  final InspectorArgument? data;
  @override
  State<InspectorEditScreen> createState() => _InspectorEditState();
}

class _InspectorEditState extends State<InspectorEditScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final InspectorService _inspectorService = InspectorService();
  final TextEditingController id = TextEditingController();
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController lastNameCtr = TextEditingController();
  final TextEditingController dniCtl = TextEditingController();
  final TextEditingController addressCtl = TextEditingController();
  final TextEditingController birthDateCtl = TextEditingController();
  final TextEditingController genderCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController userCtl = TextEditingController();
  final TextEditingController passwordCtl = TextEditingController();
  final TextEditingController rolCtl = TextEditingController();
  final TextEditingController statusCtl = TextEditingController();

  @override
  void initState() {
    id.text = widget.data?.id ?? '';
    nameCtr.text = widget.data?.name ?? '';
    lastNameCtr.text = widget.data?.lastName ?? '';
    dniCtl.text = widget.data?.dni ?? '';
    addressCtl.text = widget.data?.address ?? '';
    birthDateCtl.text = (widget.data?.birthDate ?? "") != ""
        ? (widget.data?.birthDate ?? "").substring(0, 10)
        : "";
    genderCtl.text = widget.data?.gender ?? '';
    emailCtl.text = widget.data?.email ?? '';
    userCtl.text = widget.data?.user ?? '';
    passwordCtl.text = widget.data?.password ?? '';
    rolCtl.text = widget.data?.rol ?? '';
    statusCtl.text = widget.data?.status ?? '';
    super.initState();
  }

  Future<void> addInspector() async {
    //get response from ApiClient
    InspectorModel newInspector = InspectorModel();
    newInspector.id = id.text;
    newInspector.name = nameCtr.text;
    newInspector.lastName = lastNameCtr.text;
    newInspector.dni = dniCtl.text;
    newInspector.address = addressCtl.text;
    newInspector.birthDate =
        birthDateCtl.text != "" ? DateTime.parse(birthDateCtl.text) : null;
    newInspector.gender = genderCtl.text;
    newInspector.email = emailCtl.text;
    newInspector.user = userCtl.text;
    newInspector.password = passwordCtl.text;
    newInspector.rol = rolCtl.text;
    newInspector.status = statusCtl.text;

    if (newInspector.name == "" ||
        newInspector.lastName == "" ||
        newInspector.dni == "" ||
        newInspector.user == "" ||
        newInspector.address == "") {
      _messangerKey.currentState!.showSnackBar(SnackBar(
        content: const Text('Completar todos los datos'),
        backgroundColor: Colors.red.shade300,
      ));
    } else {
      dynamic res = await _inspectorService.editDriver(newInspector);
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
  }

  @override
  Widget build(BuildContext context) {
    // InspectorArgument args =
    //     ModalRoute.of(context)!.settings.arguments as InspectorArgument;
    // setState(() {
    //   id.text = args.id;
    //   nameCtr.text = args.name;
    //   lastNameCtr.text = args.lastName;
    //   dniCtl.text = args.dni;
    //   addressCtl.text = args.address;
    //   birthDateCtl.text = args.birthDate.substring(0, 10);
    //   genderCtl.text = args.gender;
    //   emailCtl.text = args.email;
    //   userCtl.text = args.user;
    //   passwordCtl.text = args.password;
    //   rolCtl.text = args.rol;
    //   statusCtl.text = args.status;
    // });

    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: const Text("Agregar Inspector"),
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
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: nameCtr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Nombres",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Nombres',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: lastNameCtr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Apellidos",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Apellidos',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: dniCtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(8),
                  ],
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "DNI",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'DNI',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: addressCtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Direccion",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Direccion',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 55,
                child: TextField(
                  controller: birthDateCtl,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      iconColor: Colors.grey,
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Fecha Nacimiento" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            1900), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime(2101));

                    if (pickedDate != null) {
                      //setState(() {
                      birthDateCtl.text =
                          pickedDate.toString().substring(0, 10);
                      //});
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 55,
                child: DropdownButton<String>(
                  value: genderCtl.text,
                  isExpanded: true,
                  items: <String>['Hombre', 'Mujer', 'Otro']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      genderCtl.text = newValue!;
                    });
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: emailCtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Correo",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Correo',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: userCtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Usuario",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Usuario',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: passwordCtl,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    focusColor: Colors.white,
                    //errorText: "Error",

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    fillColor: Colors.grey,

                    hintText: "Contraseña",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Contraseña',
                    //lable style
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 55,
                child: DropdownButton<String>(
                  value: rolCtl.text,
                  isExpanded: true,
                  items: <String>['ADMINISTRADOR', 'INSPECTOR']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      rolCtl.text = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 226, 94),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: addInspector,
                    child: const Text('GUARDAR'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
