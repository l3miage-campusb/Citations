import 'package:flutter/material.dart';
import '../dialog/confirm_delete_dialog.dart';
import '../enum/Tags.dart';
import '../models/Citation.dart';
import '../components/bottom_nav_bar.dart';
import '../services/storage.dart';
import '../components/citation_card.dart';
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
    localstorage.removeFavorite(citations.elementAt(index));
    setState(() {
      citations.removeAt(index);
    });
  }

  void _confirmDeleteCitation(int index) {
    final citation = citations[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmer la suppression'),
          content: Text('Supprimer cette citation ?\n\n"${citation.citation}"'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
                _removeCitation(index);      // Supprimer après confirmation
              },
              child: const Text(
                'Supprimer',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
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
      appBar: AppBar(title: const Text('Favoris')),
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
                  return CitationCard(
                    citation: citation,
                    onDelete: () async {
                      final confirm = await showConfirmDeleteDialog(
                        context,
                        filteredCitations[index].citation,
                      );

                      if (confirm) {
                        final citationToRemove = filteredCitations[index];
                        final indexInOriginal = citations.indexOf(citationToRemove);
                        _removeCitation(indexInOriginal);
                      }
                    },
                  );
                },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 1),
    );
  }
}
