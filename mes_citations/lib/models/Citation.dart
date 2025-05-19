import '../enum/Tags.dart';

class Citation {
  final String citation;
  final List<Tag> tags;

  Citation({required this.citation, required this.tags});

  Map<String, dynamic> toJson() {
    return {
      'citation': citation,
      'tags': tags.map((tag) => tag.name).toList(), // Enum → String
    };
  }

  factory Citation.fromJson(Map<String, dynamic> json) {
    return Citation(
      citation: json['citation'],
      tags: (json['tags'] as List<dynamic>)
          .map((tagString) => Tag.values.firstWhere((tag) => tag.name == tagString))
          .toList(),
    );
  }
}