import 'package:flutter/material.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/user_services.dart';
import 'package:my_app/widget/lottie_controller.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:my_app/models/user.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  String getWordBeforeAtSymbol(String email) {
    if (email.contains('@')) {
      List<String> parts = email.split('@');
      return parts[0];
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final VpnService vpnService = Provider.of<VpnService>(context);
    final UserService userService = Provider.of<UserService>(context);

    String email = userService.currentUserinfo?.email ?? 'null';
    String name = email == 'null' ? 'null' : getWordBeforeAtSymbol(email);
    bool premium = userService.currentUserinfo?.isPremium ?? false;

    Future<void> goPremium() async {
      UserService userService =
          Provider.of<UserService>(context, listen: false);
      String currentToken = userService.token;
      try {
        final response = await http
            .get(Uri.parse('${dotenv.env['BACKEND_IP']}/goPremium'), headers: {
          'Authorization':
              'Bearer $currentToken', // Add Bearer token to headers
        }).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          var token = jsonResponse['newtoken'];

          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String userEmail = decodedToken['userId'];
          bool isPremium = decodedToken['premium'];
          UserService userService =
              Provider.of<UserService>(context, listen: false);
          userService.saveToken(token);
          userService.setUser(UserInfo(email: userEmail, isPremium: isPremium));
          if (!context.mounted) return;

          Navigator.pushNamedAndRemoveUntil(
              context, '/homeScreen', (Route<dynamic> route) => false,
              arguments: {'scIndex': "1"});
        } else {
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Some Error Occurs ${response.statusCode}')),
          );
        }
      } catch (err) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Some Error Occurs')),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'User',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
        child: Column(
          children: [
            const LottieController(
              ratio: 0.3,
              name: 'dance',
              type: true,
            ),
            const Text(
              'Hi ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100, 50),
                backgroundColor: Colors.red, //
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                await userService.removeObject();
                await vpnService.removeObject();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/loginScreen',
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Icon(Icons.email,
                      size: screenWidth * 0.1, color: Colors.blue),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      Text(email),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1, // You can adjust the thickness of the line
              height: 20, // Space between the line and the text above it
              indent:
                  20, // Adjust the indent if you want to make the line shorter
              endIndent:
                  20, // Adjust the end indent if you want to make the line shorter
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Image(
                    image: AssetImage('assets/logo/vip.png'),
                  ),
                  const SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4.0),
                      premium
                          ? const Text("Premium User")
                          : const Text("Free User")
                    ],
                  ),
                  const Spacer(),
                  if (!premium)
                    ElevatedButton(
                        onPressed: () async {
                          await goPremium();
                        },
                        child: const Text("GO PREMIUM"))
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1, // You can adjust the thickness of the line
              height: 20, // Space between the line and the text above it
              indent:
                  20, // Adjust the indent if you want to make the line shorter
              endIndent:
                  20, // Adjust the end indent if you want to make the line shorter
            ),
          ],
        ),
      ),
    );
  }
}
