import 'package:flutter/material.dart';
import 'package:my_app/widget/country_logo.dart';
import 'package:my_app/widget/selected_card.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lottie/lottie.dart';
import 'package:my_app/widget/animation.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() {
    return CountryScreenState();
  }
}

class CountryScreenState extends State<CountryScreen> {
  late Future<Map<String, String>> _countryNames;

  @override
  void initState() {
    super.initState();
    _countryNames = fetchCountryData();
  }

  Future<Map<String, String>> fetchCountryData() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.5:3000/vpnStatus'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      Map<String, String> data =
          Map<String, String>.from(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load country data');
    }
  }

  void goback() {
    Provider.of<VpnService>(context, listen: false).navigateTo('/homeScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Select Country"),
        leading: TextButton(
          onPressed: goback,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color.fromARGB(255, 184, 85, 230),
          ),
        ),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _countryNames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LottieW(
                lottie: 'loading',
                text: "Fetching Country List",
                color: Colors.lightBlue);
          } else if (snapshot.hasError) {
            return const LottieW(
              lottie: 'error',
              text: "Oops! Something Went Wrong",
              color: Color.fromARGB(255, 221, 128, 198),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            Map<String, String> countryData = snapshot.data!;
            return ListView.builder(
              itemCount: countryData.length,
              itemBuilder: (context, index) {
                String country = countryData.keys.elementAt(index);
                String latency = countryData.values.elementAt(index);
                return SelectableCountryCard(
                    countryLogo: CountryLogo(country: country),
                    selected: true,
                    latency: latency,
                    onTap: () {
                      goback();
                    });
              },
            );
          }
        },
      ),
    );
  }
}
