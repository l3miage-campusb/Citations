import 'package:flutter/material.dart';
import 'package:mes_citations/services/http_service.dart';

import '../enum/Tags.dart';
import '../models/Citation.dart';
import '../bottom_nav_bar.dart';
import '../services/storage.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StorageService localstorage = new StorageService();



  // Citation actuellement affichée
  Citation? currentCitation;


  //Liste de citations
  List<Citation> phrases = [];
  // Liste des favoris
  List<Citation> favorites = [];

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    localstorage.addSamplePhrases();
    getCitationTest();
    loadPhrases();
    initCitation();
  }

  Future<void> getCitationTest() async {
    await HttpService.fetchCitationByCategory(Tag.motivation);
  }

  Future<void> initCitation() async {
    final randomCitation = await localstorage.getRandomPhrase();
    setState(() {
      currentCitation = randomCitation;
    });
  }

  Future<void> loadPhrases() async {
    final phrasesList = await localstorage.getPhrases();
    setState(() {
      phrases = phrasesList;
    });
  }

  // Fonction pour changer de citation (simulé pour l'instant)
  void _getNewCitation() async {
    final newCitation = await localstorage.getRandomPhrase();

    if (newCitation != null) {
      setState(() {
        currentCitation = newCitation;
      });
    }
  }


  void _addToFavorites() {
    if (currentCitation == null) return;

    localstorage.saveFavorite(currentCitation!);
    setState(() {
      favorites.add(currentCitation!);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Citation ajoutée aux favoris !')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page d\'Accueil')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage de la citation actuelle
            Center(
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 20),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '"${currentCitation?.citation}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        currentCitation?.auteur ?? "Auteur inconnu",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: currentCitation?.tags
                            .map((tag) => Chip(
                          label: Text(tag.label),
                          visualDensity: VisualDensity.compact,
                        ))
                            .toList() ??
                            [],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Boutons en dessous de la citation
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bouton pour obtenir une nouvelle citation
                ElevatedButton(
                  onPressed: _getNewCitation,
                  child: const Text('Nouvelle Citation'),
                ),
                const SizedBox(width: 20),
                // Bouton pour ajouter aux favoris
                ElevatedButton(
                  onPressed: _addToFavorites,
                  child: const Text('Ajouter aux Favoris'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );

  }
}