import 'package:flutter/material.dart';

import '../enum/Tags.dart';
import '../models/Citation.dart';
import '../bottom_nav_bar.dart';
import '../services/local_storage_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StorageService localstorage = new StorageService();



  // Citation actuellement affichée
  Citation currentCitation = Citation(
    citation: "La vie commence là où commence ta zone de confort.",
    auteur: "Bastien",
    tags: [Tag.inspirant, Tag.motivation],
  );

  // Liste des favoris
  List<Citation> favorites = [];

  // Fonction pour changer de citation (simulé pour l'instant)
  void _getNewCitation() {
    setState(() {
      // Remplace la citation actuelle par une autre citation simulée
      currentCitation = Citation(
        citation: "Ne rêve pas ta vie, vis tes rêves.",
        auteur: "Bastien",
        tags: [Tag.inspirant],
      );
    });
  }

  // Fonction pour ajouter la citation aux favoris
  void _addToFavorites() {
    localstorage.saveFavorite(currentCitation);
    setState(() {
      favorites.add(currentCitation);
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
                        '"${currentCitation.citation}"',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '${currentCitation.auteur}',
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
                        children: currentCitation.tags
                            .map((tag) => Chip(
                          label: Text(tag.label),
                          visualDensity: VisualDensity.compact,
                        ))
                            .toList(),
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
      bottomNavigationBar: const BottomNavBar(),
    );

  }
}