import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';

class OMDbService {
  Future<void> testSearch() async {
    final url = Uri.parse('$OMDbBaseUrl?apikey=$OMDbApiKey&s=batman');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Movies found: ${data['Search']?.length ?? 0}');
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
