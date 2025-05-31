import 'package:country_api/model/country.dart';
import 'package:flutter/material.dart';

class CountryDetails extends StatelessWidget {
  final Country country;

  const CountryDetails({Key? key, required this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(country.name.common),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 245, 74, 22),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Nome oficial: ${country.name.official}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
              ),
              const SizedBox(height: 30),
              if (country.flagUrl.isNotEmpty) Image.network(country.flagUrl),
            ],
          ),
        ),
      ),
    );
  }
}
