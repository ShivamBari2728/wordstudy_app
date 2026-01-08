class OppositeWord {
  final String leftWord;
  final String rightWord;
  final String leftImage;
  final String rightImage;

  const OppositeWord({
    required this.leftWord,
    required this.rightWord,
    required this.leftImage,
    required this.rightImage,
  });

  factory OppositeWord.fromJson(Map<String, dynamic> json) {
    return OppositeWord(
      leftWord: json['leftWord'],
      rightWord: json['rightWord'],
      leftImage: json['leftImage'],
      rightImage: json['rightImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'leftWord': leftWord,
      'rightWord': rightWord,
      'leftImage': leftImage,
      'rightImage': rightImage,
    };
  }
}
