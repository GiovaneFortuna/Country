import 'dart:convert';

import 'package:country_api/const.dart';
import 'package:country_api/model/country.dart';
import 'package:http/http.dart' as http;

class CountryService {

  Future<List<Country>> getCountries() async {
    final response = await http.get(Uri.parse(base_url));

    if(response.statusCode == 200){
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => Country.fromJson(item)).toList();
    } else {
      throw Exception("Erro ao buscar o país");
    }

  }
}