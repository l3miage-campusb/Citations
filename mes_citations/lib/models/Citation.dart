import 'dart:ffi';

import '../enum/Tags.dart';

class Citation {
  final String citation;
  final String auteur;
  final List<Tag> tags;
  bool isMine;

  Citation({required this.citation,required this.auteur, required this.tags, this.isMine = false});

  Map<String, dynamic> toJson() {
    return {
      'citation': citation,
      'auteur': auteur,
      'tags': tags.map((tag) => tag.name).toList(), // Enum → String
      'isMine': isMine,
    };
  }

  factory Citation.fromJson(Map<String, dynamic> json) {
    return Citation(
      citation: json['citation'],
      auteur: json['auteur'],
      tags: (json['tags'] as List<dynamic>)
          .map((tagString) => Tag.values.firstWhere((tag) => tag.name == tagString))
          .toList(),
      isMine: json['isMine'] ?? false,
    );
  }
}