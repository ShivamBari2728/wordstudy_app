import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import 'package:wordstudy_app/Providers/practiceProgressProvider.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class VowelsPracticeScreen extends StatefulWidget {
  const VowelsPracticeScreen({super.key});

  @override
  State<VowelsPracticeScreen> createState() => _VowelsPracticeScreenState();
}

class _VowelsPracticeScreenState extends State<VowelsPracticeScreen> {
  int currentIndex = 0;
  String? selectedAnswer;
  bool? isCorrect;

  late ConfettiController _confettiController;

  final List<_PracticeQuestion> questions = [
    _PracticeQuestion(
      sentence: "This is _ Apple",
      correctAnswer: "AN",
      options: ["A", "AN", "THE"],
    ),
    _PracticeQuestion(
      sentence: "This is _ Ball",
      correctAnswer: "A",
      options: ["A", "AN", "THE"],
    ),
    _PracticeQuestion(
      sentence: "This is _ Orange",
      correctAnswer: "AN",
      options: ["A", "AN", "THE"],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void checkAnswer(String answer) {
  final correct = answer == questions[currentIndex].correctAnswer;

  setState(() {
    selectedAnswer = answer;
    isCorrect = correct;
  });

  if (correct) {
    _confettiController.play();

    /// 🔥 UPDATE REAL PROGRESS HERE
    final provider = context.read<PracticeProgressProvider>();

    final totalQuestions = questions.length;
    final completedQuestions = currentIndex + 1;

    provider.updateVowelsProgress(
      completedQuestions / totalQuestions,
    );
  }
}


  void nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        isCorrect = null;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          /// 🌄 BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/SimpleWordsBGImage.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.25),
              child: SafeArea(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    /// 📝 SENTENCE
                    _sentenceWidget(question.sentence),

                    const SizedBox(height: 40),

                    /// 🎯 OPTIONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: question.options.map((option) {
                        return _optionButton(option);
                      }).toList(),
                    ),

                    const Spacer(),

                    /// 👉 NEXT BUTTON
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primaryAppColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 10,
                        ),
                      ),
                      onPressed:
                          selectedAnswer == null ? null : nextQuestion,
                      child: const Text(
                        "NEXT",
                        style: TextStyle(
                          fontSize: 30,
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),

          /// 🎉 CONFETTI
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.orange,
                Colors.pink,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Sentence with blank
  Widget _sentenceWidget(String sentence) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        sentence.replaceFirst(
          "_",
          selectedAnswer ?? "_",
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: selectedAnswer == null
              ? Colors.white
              : isCorrect == true
                  ? Colors.greenAccent
                  : Colors.redAccent,
        ),
      ),
    );
  }

  /// 🔹 Option button (UPDATED LOGIC)
  Widget _optionButton(String option) {
    final correctAnswer = questions[currentIndex].correctAnswer;

    Color bgColor = Colors.white;

    if (selectedAnswer != null) {
      if (option == correctAnswer) {
        bgColor = Colors.green; // ✅ always show correct
      } else if (option == selectedAnswer) {
        bgColor = Colors.red; // ❌ wrong selected
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: selectedAnswer == null ? () => checkAnswer(option) : null,
        child: Container(
          width: 80,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            option,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= MODEL =================
class _PracticeQuestion {
  final String sentence;
  final String correctAnswer;
  final List<String> options;

  _PracticeQuestion({
    required this.sentence,
    required this.correctAnswer,
    required this.options,
  });
}
