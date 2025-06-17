import 'package:flutter/material.dart';
import '../pages/mes_citations_page.dart';
import '../pages/add_phrase_page.dart';

class TopNavigationBar extends StatelessWidget {
  final bool isOnAjouterPhrase;

  const TopNavigationBar({super.key, required this.isOnAjouterPhrase});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: isOnAjouterPhrase
              ? () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MesCitationsPage()),)
              : null, // desactivado si ya estás en esa página
          child: const Text('Mes citations'),
        ),
        ElevatedButton(
          onPressed: isOnAjouterPhrase
              ? null // estás en esta vista
              : () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AddPhrasePage()),),
          child: const Text('Ajouter phrase'),
        ),
      ],
    );
  }
}
