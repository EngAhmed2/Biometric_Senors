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
  @override
  initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState((){
      _supportState = isSupported;
    }),
    );
  }

  Future<void> _getAvailableBiometrics() async{
    List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    print("List of available Biometrics : $availableBiometrics");
    if (!mounted){
      return;
    }
  }

  Future<void> _authenticate() async{
    try{
      bool authenticated = await auth.authenticate(
        localizedReason: 'Subscribe to open Door',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      print("Authenticated: $authenticated");
    }on PlatformException catch(e){
      print("Authenticate exception : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_supportState)
            const Text('This Device is Supported',)
          else
            const Text('This Device is NOT Supported',style: TextStyle(fontSize: 40,),),

          const Divider(height: 100,),

          ElevatedButton(onPressed: _getAvailableBiometrics, child: const Text('Get Available Biometrics',),),

          const Divider(height: 100,),

          ElevatedButton(onPressed: _authenticate , child: const Text('Authenticate'),),
        ],
      ),
    );
  }
}
