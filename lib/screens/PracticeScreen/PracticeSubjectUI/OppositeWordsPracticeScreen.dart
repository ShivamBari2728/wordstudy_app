import 'package:confetti/confetti.dart';
import 'package:wordstudy_app/generalimports.dart';
class OppositeWordsPracticeScreen extends StatefulWidget {
  const OppositeWordsPracticeScreen({super.key});

  @override
  State<OppositeWordsPracticeScreen> createState() =>
      _OppositeWordsPracticeScreenState();
}

class _OppositeWordsPracticeScreenState
    extends State<OppositeWordsPracticeScreen> {
  int currentIndex = 0;
  String? selectedAnswer;
  bool? isCorrect;

  late ConfettiController _confettiController;

  final List<_OppositePracticeQuestion> questions = [
    _OppositePracticeQuestion(
      sentence: "The box is big",
      targetWord: "big",
      correctAnswer: "small",
      options: ["small", "tall", "fast"],
    ),
    _OppositePracticeQuestion(
      sentence: "The water is hot",
      targetWord: "hot",
      correctAnswer: "cold",
      options: ["cold", "warm", "soft"],
    ),
    _OppositePracticeQuestion(
      sentence: "The car is fast",
      targetWord: "fast",
      correctAnswer: "slow",
      options: ["slow", "big", "new"],
    ),
    _OppositePracticeQuestion(
      sentence: "The sky is day",
      targetWord: "day",
      correctAnswer: "night",
      options: ["night", "blue", "sunny"],
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

    /// 🔥 UPDATE OPPOSITE WORDS PROGRESS HERE
    final provider = context.read<PracticeProgressProvider>();

    final totalQuestions = questions.length;
    final completedQuestions = currentIndex + 1;

    provider.updateOppositesProgress(
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
                    _sentenceWidget(question),

                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: question.options.map((option) {
                        return _optionButton(option);
                      }).toList(),
                    ),

                    const Spacer(),
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

  Widget _sentenceWidget(_OppositePracticeQuestion question) {
    final replacedWord = (selectedAnswer != null && isCorrect == true)
        ? selectedAnswer!
        : question.targetWord;

    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          children: _buildSentenceSpans(
            question.sentence,
            question.targetWord,
            replacedWord,
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildSentenceSpans(
    String sentence,
    String target,
    String replacement,
  ) {
    final parts = sentence.split(target);

    return [
      TextSpan(text: parts[0]),
      TextSpan(
        text: replacement,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: selectedAnswer == null
              ? Colors.yellowAccent
              : isCorrect == true
                  ? Colors.greenAccent
                  : Colors.redAccent,
        ),
      ),
      TextSpan(text: parts[1]),
    ];
  }
  Widget _optionButton(String option) {
    final correctAnswer = questions[currentIndex].correctAnswer;
    Color bgColor = Colors.white;

    if (selectedAnswer != null) {
      if (option == correctAnswer) {
        bgColor = Colors.green;
      } else if (option == selectedAnswer) {
        bgColor = Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: selectedAnswer == null ? () => checkAnswer(option) : null,
        child: Container(
          width: 90,
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            option.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

/// ================= MODEL =================
class _OppositePracticeQuestion {
  final String sentence;
  final String targetWord;
  final String correctAnswer;
  final List<String> options;

  _OppositePracticeQuestion({
    required this.sentence,
    required this.targetWord,
    required this.correctAnswer,
    required this.options,
  });
}
