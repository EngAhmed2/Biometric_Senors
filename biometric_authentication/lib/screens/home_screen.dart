import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final LocalAuthentication auth;
  bool _supportState = false;
  Color authenticateColor = Colors.white;

  @override
  initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Subscribe to open Door',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      if (authenticated) {
        setState(() {
          authenticateColor = Colors.green;
        });
      }
    } on PlatformException catch (e) {
      setState(() {
        authenticateColor = Colors.red;
      });
      print("Authenticate exception : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_supportState)
            const Text(
              'This Device is Support Biometric Sensors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900,),
            )
          else
            const Text(
              'This Device is NOT Support Biometric Sensors',
              style: TextStyle(
                fontSize: 40,
                color: Color(0xff101010),
              ),
            ),
          const Divider(
            height: 100,
          ),
          ElevatedButton(
            onPressed: _authenticate,
            style: ElevatedButton.styleFrom(backgroundColor: authenticateColor),
            child: const Text(
              'Authenticate to Open door',
              style: TextStyle(color: Color(0xff101010)),
            ),
          ),
        ],
      ),
    );
  }
}
