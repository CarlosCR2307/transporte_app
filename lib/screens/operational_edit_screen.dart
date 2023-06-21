import 'package:flutter/material.dart';
import 'package:transporte_app/models/OperationalModel.dart';
import '../services/operational_service.dart';
import '../widgets/OperationalArgument.dart';

class OperationalEditScreen extends StatefulWidget {
  const OperationalEditScreen({Key? key, this.data}) : super(key: key);
  final OperationalArgument? data;
  @override
  State<OperationalEditScreen> createState() => _OperationalEditState();
}

class _OperationalEditState extends State<OperationalEditScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final OperationalService _operational = OperationalService();
  final TextEditingController id = TextEditingController();
  final TextEditingController nameCtr = TextEditingController();
  final TextEditingController dateCtr = TextEditingController();
  final TextEditingController timeCtl = TextEditingController();
  final TextEditingController ubicationCtl = TextEditingController();
  final TextEditingController idInspectorCtl = TextEditingController();
  final TextEditingController statusCtl = TextEditingController();

  @override
  void initState() {
    id.text = widget.data?.id ?? '';
    nameCtr.text = widget.data?.name ?? '';
    dateCtr.text = widget.data?.date ?? '';
    timeCtl.text = widget.data?.time ?? '';
    ubicationCtl.text = widget.data?.ubication ?? '';
    idInspectorCtl.text = widget.data?.idInspector ?? '';
    statusCtl.text = widget.data?.status ?? '';
    super.initState();
  }

  Future<void> editOperational() async {
    //get response from ApiClient
    OperationalModel newOperational = OperationalModel();
    newOperational.id = id.text;
    newOperational.name = nameCtr.text;
    newOperational.date = dateCtr.text;
    newOperational.time = timeCtl.text;
    newOperational.ubication = ubicationCtl.text;
    newOperational.idInspector = idInspectorCtl.text;
    newOperational.status = statusCtl.text;

    if (newOperational.name == "" ||
        newOperational.date == "" ||
        newOperational.ubication == "" ||
        newOperational.time == "") {
      _messangerKey.currentState!.showSnackBar(SnackBar(
        content: const Text('Completar todos los datos'),
        backgroundColor: Colors.red.shade300,
      ));
    } else {
      dynamic res = await _operational.editOperational(newOperational);
      if (context.mounted) {
        if (res["status"] == 200) {
          Navigator.pushNamed(context, '/operational');
        } else {
          _messangerKey.currentState!.showSnackBar(SnackBar(
            content: Text('Error: ${res["error"]}'),
            backgroundColor: Colors.red.shade300,
          ));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: true,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        key: scaffoldKey,
        //drawer: DrawerAdmin.getDrawer(context),
        appBar: AppBar(
          title: Text("Editar Operativo ${widget.data?.name ?? ''}"),
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

                    hintText: "Nombre",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Nombre',
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
                  controller: dateCtr,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      iconColor: Colors.grey,
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Fecha" //label text of field
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
                      setState(() {
                        dateCtr.text = pickedDate.toString().substring(0, 10);
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 55,
                child: TextField(
                  controller: timeCtl,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                      iconColor: Colors.grey,
                      icon: Icon(Icons.calendar_today), //icon of text field
                      labelText: "Hora" //label text of field
                      ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (pickedTime != null) {
                      setState(() {
                        timeCtl.text = pickedTime.format(context);
                      });
                    }
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                height: 45,
                child: TextField(
                  controller: ubicationCtl,
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

                    hintText: "Ubicacion",

                    //make hint text
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontFamily: "verdana_regular",
                      fontWeight: FontWeight.w400,
                    ),

                    //create lable
                    labelText: 'Ubicacion',
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
                    onPressed: editOperational,
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
