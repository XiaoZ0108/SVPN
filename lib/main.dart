import 'package:flutter/material.dart';
import 'package:my_app/screens/country_screen.dart';
import 'package:my_app/screens/forget1_screen.dart';
import 'package:my_app/screens/forget2_screen.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:my_app/services/user_services.dart';
import 'package:provider/provider.dart';
import 'package:my_app/screens/main_screen.dart';
import 'package:my_app/screens/register_screen.dart';
import 'package:my_app/screens/opt_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:my_app/services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  VpnService.initializeEngine();
  await dotenv.load(fileName: ".env");
  var status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  }
  await initializeService();
  runApp(const MyApp());
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    iosConfiguration: IosConfiguration(),
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
    ),
  );
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on("stop").listen((event) {
    service.stopSelf();
  });

  service.on('countdown').listen((event) async {
    int time = event?['allowTime'] ?? 0; // Default duration if not provided
    int t = time;
    int flag = 0;
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          service.setForegroundNotificationInfo(
            title: "SecureNet VPN",
            content: "Connected:Countdown $t",
          );
        }
      }
      t -= 1;

      flag += 1;
      if (flag > time) {
        if (service is AndroidServiceInstance) {
          service.setAsBackgroundService();
        }
        await SecureStorageService.saveTime();
        VpnService.disconnect2();

        timer.cancel();
      }
    });
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late VpnService vpnService;
  late UserService userService;
  @override
  void initState() {
    vpnService = VpnService();
    userService = UserService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => vpnService),
        ChangeNotifierProvider(create: (_) => userService),
      ],
      child: Consumer<UserService>(
        builder: (context, userService, child) {
          return MaterialApp(
            title: 'OpenVpn Demo',
            navigatorKey: vpnService.navigatorKey,
            home: userService.currentUserinfo == null
                ? const LoginScreen()
                : const MainScreen(),
            routes: {
              '/countryScreen': (context) => const CountryScreen(),
              '/homeScreen': (context) => const MainScreen(),
              '/loginScreen': (context) => const LoginScreen(),
              '/registerScreen': (context) => const RegisterScreen(),
              '/otpScreen': (context) => const OtpScreen(),
              '/forgetScreen1': (context) => const ForgetScreen1(),
              '/forgetScreen2': (context) => const ForgetScreen2()
            },
          );
        },
      ),
    );
  }
}
