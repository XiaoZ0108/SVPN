import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/user_services.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final UserService userService = Provider.of<UserService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Username: ${userService.currentUserinfo?.email ?? 'null'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${userService.currentUserinfo?.email ?? 'null'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            // Text(
            //   'Account Status: ${userService.currentUserinfo?.isPremium ? 'Premium' : 'Free'}',
            //   style: TextStyle(fontSize: 18),
            // ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Implement sign in functionality here
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    // Implement sign out functionality here
                  },
                  child: const Text('Sign Out'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
