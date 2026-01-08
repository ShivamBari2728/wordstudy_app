import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:wordstudy_app/Models/learningWordsModel.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class SimpleWordsScreen extends StatefulWidget {
  final String bgImage;
  final List<LearningWord> words;
  final VoidCallback onFinished;

  const SimpleWordsScreen({
    super.key,
    required this.bgImage,
    required this.words,
    required this.onFinished,
  });

  @override
  State<SimpleWordsScreen> createState() => _SimpleWordsScreenState();
}

class _SimpleWordsScreenState extends State<SimpleWordsScreen> {
  late FlutterTts flutterTts;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    flutterTts = FlutterTts();
    flutterTts.setLanguage("en-US");
    flutterTts.setSpeechRate(0.4);
    flutterTts.setPitch(1.2);
  }

  Future<void> speakWord(String word) async {
    await flutterTts.stop();
    await flutterTts.speak(word);
  }

  void nextWord() {
    if (currentIndex < widget.words.length - 1) {
      setState(() => currentIndex++);
    } else {
      widget.onFinished();
    }
  }

  String _getLetter(int index) {
    if (index < 0 || index > 25) return "";
    return String.fromCharCode(65 + index);
  }

  Widget _animatedLetters() {
    final center = currentIndex;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      child: Row(
        key: ValueKey(center),
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _letterBox(_getLetter(center - 1), false),
          const SizedBox(width: 12),
          _letterBox(_getLetter(center), true),
          const SizedBox(width: 12),
          _letterBox(_getLetter(center + 1), false),
        ],
      ),
    );
  }

  Widget _letterBox(String letter, bool isCenter) {
    if (letter.isEmpty) return const SizedBox(width: 48);

    return AnimatedScale(
      scale: isCenter ? 1.1 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: isCenter ? 64 : 48,
        height: isCenter ? 64 : 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isCenter ? ColorRes.primaryAppColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
          ],
        ),
        child: Text(
          letter,
          style: TextStyle(
            fontSize: isCenter ? 32 : 22,
            fontWeight: FontWeight.bold,
            color: isCenter ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWord = widget.words[currentIndex];

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.bgImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.25),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30),

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  currentWord.imageAsset,
                  height: 220,
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                currentWord.word,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () => speakWord(currentWord.word),
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    color: ColorRes.primaryAppColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up, color: Colors.white),
                ),
              ),

              const Spacer(),

              _animatedLetters(),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primaryAppColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                  ),
                  onPressed: nextWord,
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
