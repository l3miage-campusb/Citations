import 'package:localstorage/localstorage.dart';
import '../models/Citation.dart';
import '../enum/Tags.dart';
import 'dart:math';

class StorageService {
  static final LocalStorage _storage = LocalStorage('mes_citations');

  StorageService();

  static Future<void> init() async {
    await _storage.ready;
  }


  Future<void> addSamplePhrases() async {
    await _storage.ready;

    List<Citation> samplePhrases = [
      Citation(
        citation: "La vie est belle.",
        auteur: "Auteur 1",
        tags: [Tag.inspirant, Tag.motivation],
      ),
      Citation(
        citation: "Connais-toi toi-même.",
        auteur: "Socrate",
        tags: [Tag.inspirant, Tag.motivation],
      ),
      Citation(
        citation: "Le savoir est une arme.",
        auteur: "Auteur 2",
        tags: [Tag.inspirant, Tag.motivation],
      ),
      Citation(
        citation: "Rien ne sert de courir, il faut partir à point.",
        auteur: "La Fontaine",
        tags: [Tag.inspirant, Tag.motivation],
      ),
      Citation(
        citation: "Il n'y a pas de hasard, que des rendez-vous.",
        auteur: "Paul Éluard",
        tags: [Tag.inspirant, Tag.motivation],
      ),
    ];

    for (Citation c in samplePhrases) {
      await addPhrase(c);
    }

    print("✔️ 5 phrases ajoutées pour les tests.");
  }

  Future<Citation?> getRandomPhrase() async {
    final phrasesList = await getPhrases();

    if (phrasesList.isEmpty) {
      print("Aucune phrase disponible.");
      return null;
    }

    final randomIndex = Random().nextInt(phrasesList.length);
    final randomPhrase = phrasesList[randomIndex];


    return randomPhrase;
  }

  Future<void> addPhrase(Citation citation) async {
    await _storage.ready; // Asegura que el almacenamiento está listo

    // Obtener la lista actual de favoritos
    final existingData = _storage.getItem('phrases');

    List<Citation> phrases = [];

    if (existingData != null) {
      phrases = (existingData as List)
          .map((item) => Citation.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Verificar si ya existe la cita (puedes ajustar el criterio si quieres)
    if (phrases.any((c) => c.citation == citation.citation)) {
      print("Storage : Déjà présent dans les phrases");
      return;
    }

    // Agregar y guardar
    phrases.add(citation);

    await _storage.setItem(
      'phrases',
      phrases.map((c) => c.toJson()).toList(),
    );

    final fav = _storage.getItem("phrases");
    final List<dynamic> favList = fav;

    final List<Citation> citations = favList
        .map((item) => Citation.fromJson(item as Map<String, dynamic>))
        .toList();


    print("Storage : Citation ajoutée !");

  }

  Future<List<Citation>> getPhrases() async {
    await _storage.ready; // Asegura que el almacenamiento está listo

    final phrases = _storage.getItem("phrases");

    print("Mes phrases : $phrases");

    if (phrases == null) {
      print("je suis nul ?");
      return [];
    }

    final List<dynamic> favList = phrases;

    final List<Citation> citations = favList
        .map((item) => Citation.fromJson(item as Map<String, dynamic>))
        .toList();

    return citations;
  }

  Future<List<Citation>> getFavorites() async {
    await _storage.ready; // Asegura que el almacenamiento está listo

    final fav = _storage.getItem("favorites");

    print("j'ai get en favoris : $fav");

    if (fav == null) {
      print("je suis nul ?");
      return [];
    }

    final List<dynamic> favList = fav;

    final List<Citation> citations = favList
        .map((item) => Citation.fromJson(item as Map<String, dynamic>))
        .toList();

    // Debug print
    for (var citation in citations) {
      print(citation.citation);
      print(citation.auteur);
      print(citation.tags.map((t) => t.name).join(', '));
    }

    return citations;
  }

  Future<void> saveFavorite(Citation citation) async {
    await _storage.ready; // Asegura que el almacenamiento está listo

    // Obtener la lista actual de favoritos
    final existingData = _storage.getItem('favorites');

    List<Citation> favorites = [];

    if (existingData != null) {
      favorites = (existingData as List)
          .map((item) => Citation.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    // Verificar si ya existe la cita (puedes ajustar el criterio si quieres)
    if (favorites.any((c) => c.citation == citation.citation)) {
      print("Déjà présent dans les favoris");
      return;
    }

    // Agregar y guardar
    favorites.add(citation);

    await _storage.setItem(
      'favorites',
      favorites.map((c) => c.toJson()).toList(),
    );

    print("Citation ajoutée !");
  }

  Future<void> removeFavorite(Citation citation) async {
    await _storage.ready; // Asegura que el almacenamiento está listo

    final existingData = _storage.getItem('favorites');

    if (existingData == null) return;

    List<Citation> favorites = (existingData as List)
        .map((item) => Citation.fromJson(item as Map<String, dynamic>))
        .toList();

    // Elimina por contenido del texto de la cita (ajustable según lógica deseada)
    favorites.removeWhere((c) => c.citation == citation.citation);

    await _storage.setItem(
      'favorites',
      favorites.map((c) => c.toJson()).toList(),
    );

    print("Citation supprimée");
  }


  Future<void> clearStorage() async {
    await _storage.ready;
    await _storage.clear();
    print("Storage limpiado completamente.");
  }



}
