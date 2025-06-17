class BadWordFilter {

  static final List<String> _bannedWords = [
    'pute',
    'merde',
    'putain',
    'salope',
    'connard',
    'con',
    'enculé',
    'bordel',
    'chiant',
    'foutre',
    'nique',
    'bite',
    'couille',
    'branleur',
    'pédé',
    'salaud',
    'grognasse',
    'ta gueule',
    'ferme-la',
    'trou du cul',
    'enculer',
  ];

  static bool containsBannedWords(String text) {
    final lower = text.toLowerCase();
    return _bannedWords.any((word) => lower.contains(word));
  }
}
