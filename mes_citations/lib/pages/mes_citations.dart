import 'package:flutter/material.dart';
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

  Future<void> _loadCitations() async {
    await StorageService.init(); // espera a que localstorage esté listo
    List<Citation> loadedCitations = await localstorage.getPhrases();

    // Opcional: filtrar citas con auteur == "Ernesto"
    loadedCitations = loadedCitations
        .where((c) => c.auteur.trim().toLowerCase() == 'gyg')
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
                ? const Center(child: Text("Aucune citation d'Ernesto."))
                : ListView.builder(
              itemCount: citations.length,
              itemBuilder: (context, index) {
                final citation = citations[index];
                return ListTile(
                  title: Text(citation.citation),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Auteur : ${citation.auteur}'),
                      Text('Tags : ${citation.tags.map((tag) => tag.name).join(', ')}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
