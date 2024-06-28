import 'package:flutter/material.dart';
import 'package:my_app/widget/country_logo.dart';
import 'package:my_app/widget/selected_card.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/vpn_services.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() {
    return CountryScreenState();
  }
}

class CountryScreenState extends State<CountryScreen> {
  List<String> dummyVpnCountry = [
    "Singapore",
    "Australia",
    "Japan",
    "Singapore",
    "Australia",
    "Japan",
    "Singapore",
    "Australia",
    "Japan"
  ];

  @override
  void initState() {
    super.initState();
  }

  void fetchCountry() {
    setState(() {});
  }

  void goback() {
    Provider.of<VpnService>(context, listen: false).navigateTo('/homeScreen');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.height;

    List<Widget> countryWidgets = dummyVpnCountry.map((country) {
      return SelectableCountryCard(
          countryLogo: CountryLogo(
            country: country,
            ip: '1.2.3.4',
          ),
          selected: country == 'Singapore',
          onTap: goback);
    }).toList();

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
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.015),
        children: countryWidgets,
      ),
    );
  }
}
