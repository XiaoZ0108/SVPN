import 'package:flutter/material.dart';
import 'package:my_app/widget/country_logo.dart';
import 'package:my_app/widget/selected_card.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/vpn_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_app/widget/animation.dart';
import "package:my_app/models/vpn_country.dart";
import 'package:my_app/services/user_services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() {
    return CountryScreenState();
  }
}

class CountryScreenState extends State<CountryScreen> {
  late Future<Map<String, String>> _countryNames;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _countryNames = fetchCountryData();
  }

  Future<Map<String, String>> fetchCountryData() async {
    final response = await http
        .get(Uri.parse('${dotenv.env['BACKEND_IP']}/vpnStatus'))
        .timeout(const Duration(seconds: 8));

    if (response.statusCode == 200) {
      Map<String, String> data =
          Map<String, String>.from(json.decode(response.body));
      return data;
    } else {
      throw Exception('Failed to load country data');
    }
  }

  Future<String> fetchConfig(String country) async {
    UserService userService = Provider.of<UserService>(context, listen: false);
    String currentToken = userService.token;
    final response = await http.get(
        Uri.parse('${dotenv.env['BACKEND_IP']}/vpnConfig?country=$country'),
        headers: {
          'Authorization':
              'Bearer $currentToken', // Add Bearer token to headers
        }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      String config = jsonResponse['config'];
      return config;
    } else {
      throw Exception('Failed to load config');
    }
  }

  void fConfig(String country) async {
    setState(() {
      isLoading = true;
    });
    VpnService vpnService = Provider.of<VpnService>(context, listen: false);
    if (vpnService.stage?.toString() == 'connected') {
      vpnService.disconnect();
    }
    String config;
    try {
      if (country != "Default") {
        config = await fetchConfig(
            country); // Assume fetchConfig is defined elsewhere
        vpnService.setCountry(VpnCountry(country: country, config: config));
      } else {
        vpnService.setCountry(VpnCountry(country: country));
      }
      setState(() {
        isLoading = false;
      });
      goback();
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Some Error Occur')),
      );
    }
  }

  void goback() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/homeScreen',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vpnService = Provider.of<VpnService>(context, listen: false);
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, String>>(
              future: _countryNames,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LottieW(
                      lottie: 'find',
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
                          selected:
                              country == vpnService.currentCountry?.country
                                  ? true
                                  : false,
                          latency: latency,
                          onTap: () async {
                            fConfig(country);
                          });
                    },
                  );
                }
              },
            ),
    );
  }
}
