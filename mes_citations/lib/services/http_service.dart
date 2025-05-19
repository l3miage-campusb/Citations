import 'dart:convert';
import 'package:http/http.dart' as http;

import '../enum/Tags.dart';
import '../models/Citation.dart';

class HttpService {


  static Future<Citation?> fetchCitationByCategory(Tag tag) async {
    final String baseUrl = 'http://localhost:4200/getPhrase';
    try {
      final url = Uri.parse('$baseUrl/getPhrase?category=${tag.name}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final phrase = data['phrase'] as String;

        return Citation(
          citation: phrase,
          auteur: 'Auteur inconnu',
          tags: [tag],
        );
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception lors de l\'appel HTTP: $e');
    }

    return null;
  }
}
