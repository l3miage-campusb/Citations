import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../enum/Tags.dart';
import '../models/Citation.dart';

class HttpService {


  static Future<Citation?> fetchRandomForismaticQuote({Tag? tag}) async {
    final uri = Uri.parse('http://api.forismatic.com/api/1.0/?method=getQuote&format=json&lang=en');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final cleanedBody = response.body.replaceAll(r"\'", "'");
        final data = json.decode(cleanedBody);
        final phrase = data['quoteText'] as String?;
        final auteur = data['quoteAuthor']?.toString().trim();

        if (phrase != null) {
          final randomTags = _pickRandomTags(1, 3);
          return Citation(
            citation: phrase,
            auteur: (auteur != null && auteur.isNotEmpty) ? auteur : 'Auteur inconnu',
            tags: randomTags,
          );
        }
      } else {
        print('Erreur HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de l\'appel à Forismatic: $e');
    }

    return null;
  }


  static List<Tag> _pickRandomTags(int min, int max) {
    final allTags = List<Tag>.from(Tag.values);
    allTags.shuffle();

    final count = min + Random().nextInt(max - min + 1); // nombre entre min et max
    return allTags.take(count).toList();
  }
}
