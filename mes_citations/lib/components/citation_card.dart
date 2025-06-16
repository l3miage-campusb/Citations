import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // ← ajout ici
import '../../models/Citation.dart';
import '../../enum/Tags.dart';

class CitationCard extends StatelessWidget {
  final Citation citation;
  final VoidCallback? onDelete; // devient optionnel

  const CitationCard({
    super.key,
    required this.citation,
    this.onDelete,
  });

  void _shareCitation(BuildContext context) {
    final text = '"${citation.citation}"\n\n- ${citation.auteur}';
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
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
            // Tags + boutons (suppression + partage)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.blue),
                      onPressed: () => _shareCitation(context),
                      tooltip: "Partager",
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: onDelete,
                        tooltip: "Supprimer",
                      ),
                  ],
                ),
              ],
            ),
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
  }
}
