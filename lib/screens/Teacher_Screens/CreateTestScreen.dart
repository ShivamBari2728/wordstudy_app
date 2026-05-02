import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class Createtestscreen extends StatefulWidget {
  const Createtestscreen({super.key});

  @override
  State<Createtestscreen> createState() => _CreatetestscreenState();
}

class _CreatetestscreenState extends State<Createtestscreen> {
  /// 🔹 Step control
  int currentStep = 0;

  /// 🔹 Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  /// 🔹 Questions list
  List<Map<String, dynamic>> questions = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    addQuestion();
  }

  void addQuestion() {
    setState(() {
      questions.add({
        "question": TextEditingController(),
        "options": List.generate(4, (_) => TextEditingController()),
        "correctIndex": 0,
      });
    });
  }

  void removeQuestion(int index) {
    if (questions.length == 1) return;
    setState(() {
      questions.removeAt(index);
    });
  }

  Future<void> saveTest() async {
    final title = titleController.text.trim();
    final grade = gradeController.text.trim();

    if (title.isEmpty || grade.isEmpty) return;

    final formattedQuestions = questions.map((q) {
      return {
        "question": q["question"].text.trim(),
        "options": (q["options"] as List<TextEditingController>)
            .map((o) => o.text.trim())
            .toList(),
        "correctIndex": q["correctIndex"],
      };
    }).toList();

    setState(() => isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final docRef = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .collection("tests")
          .add({
        "title": title,
        "grade": grade,
        "questions": formattedQuestions,
        "created_at": FieldValue.serverTimestamp(),
      });

      final testCode = docRef.id;

      if (!mounted) return;

      setState(() => isLoading = false);

      _showSuccessDialog(testCode);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _showSuccessDialog(String code) {
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
                  "Test Created 🎉",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Share this code with students",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 16),

                /// CODE BOX
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    /// Copy
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: code));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Copied")),
                          );
                        },
                        child: _btn("Copy", Colors.white.withOpacity(0.2)),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Done
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: _btn("Done", ColorRes.primaryAppColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _btn(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  /// 🎨 Background wrapper
  Widget _bg({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/images/SimpleWordsBGImage.png"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.45),
            BlendMode.darken,
          ),
        ),
      ),
      child: SafeArea(child: child),
    );
  }

  Widget _input(TextEditingController controller, String hint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
      ),
    );
  }

  /// 🧠 STEP 1: Title + Grade
  Widget _buildStep1() {
    return _bg(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Create Test",
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            _input(titleController, "Enter test title"),
            _input(gradeController, "Enter grade"),

            const Spacer(),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primaryAppColor,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
              ),
              onPressed: () {
                if (titleController.text.isEmpty ||
                    gradeController.text.isEmpty) return;

                setState(() => currentStep = 1);
              },
              child: const Text("Next"),
            )
          ],
        ),
      ),
    );
  }

  /// 🧠 STEP 2: Questions
  Widget _buildStep2() {
    return _bg(
      child: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            "Add Questions",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _input(q["question"], "Enter question"),
                          ),
                          IconButton(
                            onPressed: () => removeQuestion(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Options
                      ...List.generate(4, (i) {
                        return Row(
                          children: [
                            Radio(
                              value: i,
                              groupValue: q["correctIndex"],
                              onChanged: (val) {
                                setState(() {
                                  q["correctIndex"] = val;
                                });
                              },
                            ),
                            Expanded(
                              child: _input(
                                  q["options"][i], "Option ${i + 1}"),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),

          /// Bottom Buttons
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: addQuestion,
                    child: const Text("+ Add"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : saveTest,
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text("Save"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentStep == 0 ? _buildStep1() : _buildStep2(),
    );
  }
}