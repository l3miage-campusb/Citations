import 'package:flutter/material.dart';
import 'package:mes_citations/components/citation_card.dart';
import '../components/top_navigation_bar.dart';
import '../components/bottom_nav_bar.dart';
import '../models/Citation.dart';
import '../services/storage.dart';

class MesCitationsPage extends StatefulWidget {
  const MesCitationsPage({Key? key}) : super(key: key);

  @override
  State<MesCitationsPage> createState() => _MesCitationsPageState();
}

class _MesCitationsPageState extends State<MesCitationsPage> {
  final StorageService localstorage = StorageService();

  List<Citation> citations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCitations();
  }

  void _addToFavorites(Citation citation) {

    localstorage.saveFavorite(citation);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phrase ajoutée avec succès!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _loadCitations() async {
    await StorageService.init(); // espera a que localstorage esté listo
    List<Citation> loadedCitations = await localstorage.getPhrases();

    loadedCitations.forEach((c) => print("c cita : ${c.citation} c is mine : ${c.isMine}"));
    loadedCitations = loadedCitations
        .where((c) => c.isMine == true)
        .toList();

    setState(() {
      citations = loadedCitations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Citations')),
      body: Column(
        children: [
          const TopNavigationBar(isOnAjouterPhrase: false),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : citations.isEmpty
                ? const Center(child: Text("Aucune citation personnelle."))
                : ListView.builder(
              itemCount: citations.length,
              itemBuilder: (context, index) {
                final citation = citations[index];
                return CitationCard(citation : citation,onFavorite: () => _addToFavorites(citation),);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
