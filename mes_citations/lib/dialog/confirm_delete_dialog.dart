import 'package:flutter/material.dart';

Future<bool> showConfirmDeleteDialog(BuildContext context, String citationText) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Supprimer cette citation ?\n\n"$citationText"'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false), // Annuler
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true), // Confirmer
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  ) ?? false;
}
