import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mes_citations/services/http_service.dart';

import '../components/citation_card.dart';
import '../enum/Tags.dart';
import '../models/Citation.dart';
import '../components/bottom_nav_bar.dart';
import '../services/notifications.dart';
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
    //await HttpService.fetchCitationByCategory(Tag.motivation);
    await HttpService.fetchRandomForismaticQuote();
  }

  Future<void> initCitation() async {
    final randomCitation = await HttpService.fetchRandomForismaticQuote();
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
    final bool useApi = Random().nextBool();

    final newCitation = useApi
        ? await HttpService.fetchRandomForismaticQuote()
        : await localstorage.getRandomPhrase();

    if (newCitation != null) {
      setState(() {
        currentCitation = newCitation;
      });
    }
  }


  void _addToFavorites() {
    if (currentCitation == null) return;

    localstorage.saveFavorite(currentCitation!);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Citation ajoutée aux favoris !'),
        backgroundColor: Colors.green,
      ),
    );

  }

  void _enableDailyNotification() async {
    await NotificationService.scheduleDailyCitationNotification(hour: 9, minute: 0);


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification quotidienne activée à 9h'),
        backgroundColor: Colors.green,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Page d\'Accueil'),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active),
              tooltip: 'Activer la notification quotidienne',
              onPressed: _enableDailyNotification,
            ),
          ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Affichage de la citation actuelle
            if(currentCitation != null)
              CitationCard(citation: currentCitation!,
                          onFavorite: _addToFavorites,)
              ,
            // Boutons en dessous de la citation
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 20,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: _getNewCitation,
                  child: const Text('Nouvelle Citation'),
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