import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/sessionManager.dart';

class Teacherquestionsviewer extends StatefulWidget {
  final String code;

  const Teacherquestionsviewer({super.key, required this.code});

  @override
  State<Teacherquestionsviewer> createState() =>
      _TeacherquestionsviewerState();
}

class _TeacherquestionsviewerState extends State<Teacherquestionsviewer> {
  List questions = [];
  int currentIndex = 0;
  List<int?> selectedAnswers = [];
  bool isLoading = true;
  String title = "";

  @override
  void initState() {
    super.initState();
    fetchTest();
  }

  /// 🔥 FETCH TEST
  Future<void> fetchTest() async {
    try {
      final teachers =
          await FirebaseFirestore.instance.collection("teachers").get();

      for (var teacher in teachers.docs) {
        final doc = await teacher.reference
            .collection("tests")
            .doc(widget.code)
            .get();

        if (doc.exists) {
          final data = doc.data()!;

          if (!mounted) return;

          setState(() {
            questions = data["questions"] ?? [];
            selectedAnswers =
                List.generate(questions.length, (_) => null);
            title = data["title"] ?? "";
            isLoading = false;
          });

          return;
        }
      }

      if (!mounted) return;
      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  /// 👉 NEXT / SUBMIT
  void nextQuestion() {
    if (selectedAnswers[currentIndex] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an option")),
      );
      return;
    }

    if (currentIndex < questions.length - 1) {
      setState(() => currentIndex++);
    } else {
      submitTest();
    }
  }

  /// 🧠 CALCULATE SCORE
  void submitTest() async {
    int score = 0;

    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]["correctIndex"]) {
        score++;
      }
    }

    /// 🔥 STORE RESULT
    await FirebaseFirestore.instance.collection("test_results").add({
        "testCode": widget.code,
         "testTitle": title,
  "score": score,
  "total": questions.length,

  /// 🔥 ADD THESE
  "studentName": await SessionManager.getStudentName(),
  "studentGrade": await SessionManager.getStudentGrade(),

  "timestamp": FieldValue.serverTimestamp(),
    });

    if (!mounted) return;

    _showResultDialog(score);
  }

  /// 🎉 RESULT POPUP (THEMED)
  void _showResultDialog(int score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your Score 🎉",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  "$score / ${questions.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: ColorRes.primaryAppColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("Test not found")),
      );
    }

    final q = questions[currentIndex];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/SimpleWordsBGImage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.35),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// 🔥 TITLE
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔥 PROGRESS
                  Text(
                    "${currentIndex + 1} / ${questions.length}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔥 QUESTION CARD
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [

                          Text(
                            q["question"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Expanded(
                            child: ListView.builder(
                              itemCount: q["options"].length,
                              itemBuilder: (context, i) {
                                return _optionCard(
                                  text: q["options"][i],
                                  index: i,
                                  isSelected:
                                      selectedAnswers[currentIndex] == i,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 🔘 BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primaryAppColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: nextQuestion,
                      child: Text(
                        currentIndex == questions.length - 1
                            ? "SUBMIT"
                            : "NEXT",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 OPTION CARD
  Widget _optionCard({
    required String text,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAnswers[currentIndex] = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorRes.primaryAppColor.withOpacity(0.7)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}