import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // ← ajout ici
import '../../models/Citation.dart';
import '../../enum/Tags.dart';
import '../services/storage.dart';

class CitationCard extends StatefulWidget {
  final Citation citation;
  final VoidCallback? onDelete;
  final VoidCallback? onFavorite;
  final bool showFavoriteButton;

  const CitationCard({
    super.key,
    required this.citation,
    this.onDelete,
    this.onFavorite,
    this.showFavoriteButton = true,
  });

  @override
  State<CitationCard> createState() => _CitationCardState();
}

class _CitationCardState extends State<CitationCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final favorites = await StorageService().getFavorites();
    final fav = favorites.any((c) => c.citation == widget.citation.citation);
    setState(() {
      isFavorite = fav;
    });
  }

  void _shareCitation(BuildContext context) {
    final text = '"${widget.citation.citation}"\n\n- ${widget.citation.auteur}';
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
                    children: widget.citation.tags
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
                    if (widget.showFavoriteButton)
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.pink,
                        ),
                        onPressed: isFavorite ? null : widget.onFavorite,
                        tooltip: isFavorite ? "Déjà en favoris" : "Ajouter aux favoris",
                      ),
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.blue),
                      onPressed: () => _shareCitation(context),
                      tooltip: "Partager",
                    ),
                    if (widget.onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: widget.onDelete,
                        tooltip: "Supprimer",
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.citation.citation,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              widget.citation.auteur,
              style: const TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
