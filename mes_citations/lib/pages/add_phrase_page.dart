import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import '../components/top_navigation_bar.dart';
import '../utils/bad_word_filter.dart';
import '../models/Citation.dart';
import '../enum/Tags.dart';
import '../services/storage.dart';

class AddPhrasePage extends StatefulWidget {
  const AddPhrasePage({Key? key}) : super(key: key);

  @override
  _AddPhrasePageState createState() => _AddPhrasePageState();
}

class _AddPhrasePageState extends State<AddPhrasePage> {
  final _formKey = GlobalKey<FormState>(); // para manejar el estado del formulario
  final TextEditingController _phraseController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  List<String> _selectedTags = [];
  StorageService localstorage = new StorageService();


  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }




  void _submitForm() {


    final phrase = _phraseController.text;
    final author = _authorController.text;

    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner au moins un tag.')),
      );
      return;
    }

    if (BadWordFilter.containsBannedWords(phrase) || BadWordFilter.containsBannedWords(author)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Langage inapproprié détecté. Veuillez reformuler la phrase.')),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {

      Citation citation = Citation(
        citation: phrase,
        auteur: author,
        tags: _selectedTags.map((tagString) {
          switch (tagString) {
            case 'Drôle':
              return Tag.drole;
            case 'Inspirant':
              return Tag.inspirant;
            case 'Amour':
              return Tag.amour;
            case 'Motivation':
              return Tag.motivation;
            case 'Sagesse':
              return Tag.sagesse;
            case 'Bonheur':
              return Tag.bonheur;
            default:
              throw Exception('Tag inconnu');
          }
        }).toList(),
      );

      _phraseController.clear();
      _authorController.clear();
      _selectedTags.clear();

      setState(() {}); // Para actualizar la UI y limpiar dropdown

      FocusScope.of(context).unfocus();

      print("En submit form");
      for(var tag in _selectedTags) print(tag);
      localstorage.addPhrase(citation);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phrase ajoutée avec succès!')),
      );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter une phrase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const TopNavigationBar(isOnAjouterPhrase: true),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _phraseController,
                  decoration: const InputDecoration(
                    labelText: 'Phrase',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer une phrase';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: 'Auteur',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Veuillez entrer une phrase';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: ['Drôle', 'Inspirant', 'Amour', 'Motivation', 'Sagesse', 'Bonheur'].map((tag) {
                      final isSelected = _selectedTags.contains(tag);
                      return ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedTags.add(tag);
                            } else {
                              _selectedTags.remove(tag);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('OK'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: localstorage.clearStorage,
                  child: const Text('Erase Storage'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
