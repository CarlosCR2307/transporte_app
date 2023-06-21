import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:transporte_app/api_service.dart';
import 'package:transporte_app/screens/dealership_add_screen.dart';
import 'package:transporte_app/screens/dealership_edit_screen.dart';
import 'package:transporte_app/screens/dealership_screen.dart';
import 'package:transporte_app/screens/dealership_view_screen.dart';
import 'package:transporte_app/screens/driver_add_screen.dart';
import 'package:transporte_app/screens/driver_edit_screen.dart';
import 'package:transporte_app/screens/driver_screen.dart';
import 'package:transporte_app/screens/driver_view_screen.dart';
import 'package:transporte_app/screens/home_screen.dart';
import 'package:transporte_app/screens/inspector_edit_screen.dart';
import 'package:transporte_app/screens/inspector_screen.dart';
import 'package:transporte_app/screens/inspector_add_screen.dart';
import 'package:transporte_app/screens/inspector_view_screen.dart';
import 'package:transporte_app/screens/operational_add_screen.dart';
import 'package:transporte_app/screens/operational_edit_screen.dart';
import 'package:transporte_app/screens/operational_screen.dart';
import 'package:transporte_app/screens/operational_view_screen.dart';
import 'package:transporte_app/screens/report_screen.dart';
import 'package:transporte_app/screens/report_view_screen.dart';
import 'package:transporte_app/screens/transport_add_screen.dart';
import 'package:transporte_app/screens/transport_edit_screen.dart';
import 'package:transporte_app/screens/transport_screen.dart';
import 'package:transporte_app/screens/transport_view_screen.dart';
import 'package:transporte_app/screens/operational_add_transport.dart';
import 'package:transporte_app/screens/operational_view_transport.dart';
import 'package:transporte_app/screens/webview_screen.dart';
import 'package:transporte_app/widgets/InspectorArgument.dart';
import 'package:transporte_app/widgets/OperationalArgument.dart';
import 'package:transporte_app/widgets/TransportArgument.dart';
import 'package:transporte_app/widgets/operationaldetail_argument.dart';

import 'models/UserModel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      title: "Transportes",
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/inspector': (context) => const InspectorScreen(),
        '/inspectorAdd': (context) => const InspectorAddScreen(),
        '/inspectorEdit': (context) => InspectorEditScreen(
            data: ModalRoute.of(context)!.settings.arguments
                as InspectorArgument),
        '/inspectorView': (context) => const InspectorViewScreen(),
        '/transport': (context) => const TransportScreen(),
        '/transportAdd': (context) => const TransportAddScreen(),
        '/transportEdit': (context) => TransportEditScreen(
            data: ModalRoute.of(context)!.settings.arguments
                as TransportArgument),
        '/transportView': (context) => const TransportViewScreen(),
        '/driver': (context) => const DriverScreen(),
        '/driverAdd': (context) => const DriverAddScreen(),
        '/driverEdit': (context) => const DriverEditScreen(),
        '/driverView': (context) => const DriverViewScreen(),
        '/dealership': (context) => const DealershipScreen(),
        '/dealershipAdd': (context) => const DealershipAddScreen(),
        '/dealershipEdit': (context) => const DealershipEditScreen(),
        '/dealershipView': (context) => const DealershipViewScreen(),
        '/operational': (context) => const OperationalScreen(),
        '/operationalAdd': (context) => const OperationalAddScreen(),
        '/operationalEdit': (context) => OperationalEditScreen(
            data: ModalRoute.of(context)!.settings.arguments
                as OperationalArgument),
        '/operationalView': (context) => OperationalViewScreen(
            data: ModalRoute.of(context)!.settings.arguments
                as OperationalArgument),
        '/operationalTransportAdd': (context) => OperationalAddTransportScreen(
            data: ModalRoute.of(context)!.settings.arguments
                as TransportArgument),
        '/operationalTransportView': (context) =>
            OperationalViewTransportScreen(
                data: ModalRoute.of(context)!.settings.arguments
                    as OperationalDetailArgument),
        '/viewWeb': (context) => WebViewScreen(
            url: ModalRoute.of(context)!.settings.arguments as String),
        '/report': (context) => const ReportScreen(),
        '/reportView': (context) => ReportViewScreen(
            data: ModalRoute.of(context)!.settings.arguments
                as OperationalArgument),
      },
      home: const Scaffold(
        backgroundColor: Color.fromARGB(255, 135, 170, 252),
        body: LoginScreen(),
      ),
    );
  }
}

// Home Screen
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _messangerKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    userController.text = "";
    passwordController.text = "";
    super.initState();
  }

  Future<void> loginUsers() async {
    //get response from ApiClient
    dynamic res = await _apiService.login(
      userController.text,
      passwordController.text,
    );

    if (context.mounted) {
      if (res['status'] == 200) {
        User user = User(id: res['id'], name: res['name'], rol: res['rol']);
        await SessionManager()
            .set('user', user)
            .then((value) => Navigator.pushNamed(context, '/home'));
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${res['errorDetail']}'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // hide the debug banner
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: _messangerKey,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color.fromARGB(255, 135, 170, 252),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              const Center(child: Image(image: AssetImage('images/icon.png'))),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextField(
                  controller: userController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    )),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    hintText: 'Usuario',
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    )),
                    filled: true,
                    fillColor: Color.fromARGB(255, 255, 255, 255),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    hintText: 'Contraseña',
                  ),
                ),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 40,
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
              //     child: TextButton(
              //       style: TextButton.styleFrom(
              //         foregroundColor: Colors.white,
              //       ),
              //       child: const Text('Olvidaste tu contraseña?'),
              //       onPressed: () => showDialog<String>(
              //         context: context,
              //         builder: (BuildContext context) => AlertDialog(
              //           title: const Text('Olvido su contraseña'),
              //           actions: <Widget>[
              //             TextButton(
              //               onPressed: () => Navigator.pop(context, 'Cancel'),
              //               child: const Text('Cancel'),
              //             ),
              //             TextButton(
              //               onPressed: () => Navigator.pop(context, 'OK'),
              //               child: const Text('OK'),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 3, 3, 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    onPressed: loginUsers,
                    child: const Text('INICIAR SESION'),
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
