import 'dart:convert';

import 'package:localstorage/localstorage.dart';
import '../models/Citation.dart';


class StorageService {
  static final StorageService _sharedInstance = StorageService._internal();
  factory StorageService() => _sharedInstance;
  StorageService._internal();



  Future<void> init() async {
    await initLocalStorage();
  }

  Future<List<Citation>> getFavorites() async {
    final fav = localStorage.getItem("favorites");
    print("j ai get en favoris : $fav");


    if (fav == null ) {
      print("je susi nul ?");
      return [];
    }
    // 1. Décoder le string JSON en liste dynamique
    final List<dynamic> favList = json.decode(fav);

    // 2. Convertir chaque élément en un objet Citation
    final List<Citation> citations = favList
        .map((item) => Citation.fromJson(item as Map<String, dynamic>))
        .toList();

    // Vérif
    for (var citation in citations) {
      print(citation.citation); // → La vie commence...
      print(citation.auteur); // → Bastien
      print(citation.tags.map((t) => t.name).join(', ')); // → inspirant, motivation
    }

    return citations;

  }

  Future<void> saveFavorite(Citation citation) async {

    print("je save le favorite : $citation");
    final favorites = await getFavorites();

    if (favorites.any((c) => c.citation == citation.citation)) return;

    favorites.add(citation);
    localStorage.setItem(
      'favorites',
      json.encode(favorites.map((c) => c.toJson()).toList()),
    );

    getFavorites();
  }

  Future<void> removeFavorite(Citation citation) async {

    final favorites = await getFavorites();

    print("je suppr le favorite : $citation");

    favorites.removeWhere((c) => c.citation == citation.citation);

    localStorage.setItem(
      'favorites',
      favorites.map((c) => c.toJson()).toList().toString(),
    );

    print("j ai apres ");
    getFavorites();
  }

  Future<void> clearFavorites() async {

    localStorage.removeItem('favorites');
  }
}
