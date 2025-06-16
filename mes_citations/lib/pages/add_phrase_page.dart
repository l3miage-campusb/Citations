import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
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
  String? _selectedTag;
  StorageService localstorage = new StorageService();



  @override
  void dispose() {
    _phraseController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Aquí puedes manejar la frase ingresada
      final phrase = _phraseController.text;
      final author = _authorController.text;
      final tag = _selectedTag!;


      // Por ejemplo, limpiar el campo después de enviar
      _phraseController.clear();
      _authorController.clear();
      _selectedTag = null;

      FocusScope.of(context).unfocus();

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phrase ajoutée avec succès!')),
      );
      Citation citation = Citation(
        citation: phrase,
        auteur: author,
        tags: [Tag.inspirant, Tag.motivation],
      );
      localstorage.addPhrase(citation);

      setState(() {}); // Para actualizar la UI y limpiar dropdown
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
          key: _formKey, // vinculamos el key al formulario
          child: Column(
            children: [
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
                  return null; // si es válido
                },
              ),
              const SizedBox(height: 20),
              /*ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Ajouter'),
              ),*/
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
                  return null; // si es válido
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Tag',
                  border: OutlineInputBorder(),
                ),
                value: _selectedTag,
                items: ['Drôle', 'Inspirant', 'Amour', 'Motivation']
                    .map((tag) => DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTag = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez choisir un tag';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('OK'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: localstorage.clearStorage,
                child: const Text('Erase Storage'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 2),
    );
  }
}
