import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

import '../enum/Tags.dart';
import '../models/Citation.dart';
import '../bottom_nav_bar.dart';
import '../services/local_storage_service.dart';
import 'dart:developer';


class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});





  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  StorageService localstorage = new StorageService();
  List<Citation> citations = [];


  @override
  void initState() {
    super.initState();
    loadFavorites();
  }
  Future<void> loadFavorites() async {
    final favorites = await localstorage.getFavorites();
    setState(() {
      citations = favorites;
    });
  }






  // Liste des tags sélectionnés
  List<Tag> selectedTags = [];

  void _removeCitation(int index) {
    print("testlog");
    localstorage.removeFavorite(citations.elementAt(index));
    setState(() {
      citations.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filtrer les citations par les tags sélectionnés avec un "OU"
    final filteredCitations = selectedTags.isEmpty
        ? citations
        : citations.where((citation) {
      // Retourne true si la citation contient **au moins un** des tags sélectionnés
      return citation.tags.any((tag) => selectedTags.contains(tag));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Mes Citations')),
      body: Column(
        children: [
          // Filtre par tags
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 8,
              children: Tag.values.map((tag) {
                //Pour chque tag de l'enum on met un filter chip en haut
                return FilterChip(
                  label: Text(tag.label),
                  selected: selectedTags.contains(tag),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedTags.add(tag);  // Ajoute le tag sélectionné
                      } else {
                        selectedTags.remove(tag);  // Retire le tag désélectionné
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          // Affichage des citations
          Expanded(
            child: filteredCitations.isEmpty
                ? const Center(child: Text('Aucune citation correspondant à ce filtre.'))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: filteredCitations.length,
              itemBuilder: (context, index) {
                final citation = filteredCitations[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              //Les tags
                              child: Wrap(
                                spacing: 8,
                                runSpacing: -8,
                                children: citation.tags
                                    .map((tag) => Chip(
                                  label: Text(
                                    tag.label,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ))
                                    .toList(),
                              ),
                            ),
                            //Bouton de suppression
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeCitation(index),
                            ),
                          ],
                        ),
                        //La citation
                        const SizedBox(height: 12),
                        Text(
                          citation.citation,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          citation.auteur,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
