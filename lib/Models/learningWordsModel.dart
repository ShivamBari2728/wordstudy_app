class LearningWord {
  final String word;
  final String imageAsset;

  LearningWord({
    required this.word,
    required this.imageAsset,
  });

  factory LearningWord.fromJson(Map<String, dynamic> json) {
    return LearningWord(
      word: json['word'] as String,
      imageAsset: json['imageAsset'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'imageAsset': imageAsset,
    };
  }
}
