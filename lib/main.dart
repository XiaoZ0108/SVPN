import 'package:flutter/material.dart';
import 'package:my_app/models/vpn_country.dart';
import 'package:my_app/screens/country_screen.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/main_screen.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:my_app/screens/opt_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late VpnService vpnService;

  @override
  void initState() {
    vpnService = VpnService();
    super.initState();
  }

  void setCountry(VpnCountry vc) {
    setState(() {
      vpnService.setCountry(vc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => vpnService,
      child: Consumer<VpnService>(
        builder: (context, vpnService, child) {
          return MaterialApp(
            title: 'OpenVpn Demo',
            navigatorKey: vpnService.navigatorKey,
            home: const MainScreen(),
            routes: {
              '/countryScreen': (context) => const CountryScreen(),
              '/homeScreen': (context) => const MainScreen(),
              '/loginScreen': (context) => const LoginScreen(),
              '/registerScreen': (context) => const RegisterScreen(),
              '/otpScreen': (context) => const OtpScreen(),
            },
          );
        },
      ),
    );
  }
}
