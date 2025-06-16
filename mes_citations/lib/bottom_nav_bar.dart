import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/favorite_page.dart';
import 'pages/add_phrase_page.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: Color(0xFFF3E5F5), // fondo lavanda claro
      selectedItemColor: Color(0xFF6A1B9A), // morado fuerte
      unselectedItemColor: Color(0xFFCE93D8), // lavanda suave
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favoris',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box),
          label: 'Ajouter Phrase',
        ),
      ],
      onTap: (int index) {
        if (index == currentIndex) return;
        // Gérer la navigation vers la page appropriée
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const FavoritesPage()),
          );
        }
        else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AddPhrasePage()),
          );
        }
      },
    );
  }
}
