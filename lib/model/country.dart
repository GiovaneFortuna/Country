import 'package:country_api/model/name.dart';

class Country {
  final Name name;
  final String flagUrl;

  Country({required this.name, required this.flagUrl});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: Name.fromJson(json['name']),
      flagUrl: json['flags']?['png'] ?? '',
    );
  }
}