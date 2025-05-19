enum Tag {
  inspirant,
  drole,
  amour,
  motivation,
}

extension TagExtension on Tag {
  String get label {
    switch (this) {
      case Tag.inspirant:
        return 'Inspirant';
      case Tag.drole:
        return 'Drôle';
      case Tag.amour:
        return 'Amour';
      case Tag.motivation:
        return 'Motivation';
    }
  }
}