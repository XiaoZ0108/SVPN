import 'package:flutter/material.dart';
import 'package:my_app/widget/country_logo.dart';

class SelectableCountryCard extends StatelessWidget {
  final CountryLogo countryLogo;
  final bool selected;
  final VoidCallback onTap;

  const SelectableCountryCard(
      {required this.countryLogo,
      required this.selected,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color:
            selected ? const Color.fromARGB(255, 184, 85, 230) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: countryLogo,
        ),
      ),
    );
  }
}
