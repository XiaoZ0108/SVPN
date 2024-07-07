import 'package:http/http.dart' as http;
import 'dart:convert';

class VpnCountry {
  VpnCountry({required this.country, this.config});

  final String country;
  final String? config;

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'config': config,
    };
  }

  factory VpnCountry.fromJson(Map<String, dynamic> json) {
    return VpnCountry(
      country: json['country'],
      config: json['config'],
    );
  }

  static Future<String> fetchIpAddress() async {
    try {
      var response = await http.get(Uri.parse('https://ipv4.seeip.org/jsonip'));
      if (response.statusCode == 200) {
        String res = response.body;
        Map<String, dynamic> json = jsonDecode(res);
        return json['ip'];
      } else {
        return "N/A";
      }
    } catch (e) {
      return "N/A";
    }
  }
}
