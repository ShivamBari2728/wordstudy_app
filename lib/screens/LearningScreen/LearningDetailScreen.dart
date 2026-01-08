import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:wordstudy_app/Models/learningWordsModel.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/screens/LearningScreen/SubjectsScreenUI/OppositeWordsHome.dart';
import 'package:wordstudy_app/screens/LearningScreen/SubjectsScreenUI/SimpleWordsHome.dart';
import 'package:wordstudy_app/screens/LearningScreen/SubjectsScreenUI/VowelsHome.dart';
import 'package:wordstudy_app/services/learning_words_service.dart';

enum LearningSubjectType { simpleWords, vowels, oppositeWords }

class LearningDetailScreen extends StatefulWidget {
  final LearningSubjectType subjectType;

  const LearningDetailScreen({super.key, required this.subjectType});

  @override
  State<LearningDetailScreen> createState() => _LearningDetailScreenState();
}

class _LearningDetailScreenState extends State<LearningDetailScreen> {
  late FlutterTts flutterTts;

  late String title;
  late String bgImage;
  List<LearningWord> words = [];

  bool isLoading = true;

  final LearningWordsService _learningWordsService =
      LearningWordsService();

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.4);
    flutterTts.setPitch(1.2);

    _loadDataBasedOnSubject();
  }

  /// 🔊 Speak word
  Future<void> speakWord(String word) async {
    await flutterTts.stop();
    await flutterTts.speak(word);
  }

  /// 🔁 Load data using SERVICE
  Future<void> _loadDataBasedOnSubject() async {
    switch (widget.subjectType) {
      case LearningSubjectType.simpleWords:
        title = "Simple Words";
        bgImage = "assets/images/SimpleWordsBGImage.png";
        words = await _learningWordsService.fetchSimpleWords();
        break;

      case LearningSubjectType.vowels:
        title = "Vowels";
        bgImage = "";
        break;

      case LearningSubjectType.oppositeWords:
        title = "Opposite Words";
        bgImage = "";
        break;
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: widget.subjectType == LearningSubjectType.simpleWords
          ? SimpleWordsScreen(
              bgImage: bgImage,
              words: words,
              onFinished: () => Navigator.pop(context),
            )
          : widget.subjectType == LearningSubjectType.vowels
              ? VowelsIntroScreen(
                  onFinished: () => Navigator.pop(context),
                )
              : widget.subjectType == LearningSubjectType.oppositeWords
                  ? OppositeWordsScreen(
                      onFinished: () => Navigator.pop(context),
                    )
                  : const SizedBox(),
    );
  }
}
