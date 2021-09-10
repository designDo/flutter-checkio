import 'dart:math';

class LoLWords {
  final String word;
  final String wordEnglish;

  LoLWords(this.word, this.wordEnglish);
}

class LoLWordsFactory {
  static List<LoLWords> words = [
    LoLWords('且随疾风前行，身后亦须留心。', 'Follow the wind, but watch your back.'),
    LoLWords('哼，一个能打的都没有。', 'Who wants a piece of the champ?')
  ];

  static LoLWords randomWord() {
    return words[Random().nextInt(words.length)];
  }
}
