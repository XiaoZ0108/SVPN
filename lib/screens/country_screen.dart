import 'package:flutter/material.dart';
import 'package:my_app/models/vpn_country.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});
  @override
  State<CountryScreen> createState() {
    return CountryScreenState();
  }
}

class CountryScreenState extends State<CountryScreen> {
  List<VpnCountry> vpnCountry = [];

  @override
  void initState() {
    super.initState();
  }

  void fetchCountry() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
