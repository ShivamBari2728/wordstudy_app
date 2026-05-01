import 'package:flutter/material.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/LearningScreen/TeacherLessionView/TeacherLessonViewer.dart';
import 'package:wordstudy_app/screens/LearningScreen/learningCard.dart';
import 'package:wordstudy_app/constants.dart' as constains;

class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {

  /// 🔥 Controller for code input
  final TextEditingController codeController = TextEditingController();

  final List<LearningItem> learningItems = [
    LearningItem(
      level: "Level 1",
      title: "Simple Words",
      bgImageUrl: "assets/images/learningCardsBG/SimpleWordsBG.png",
    ),
    LearningItem(
      level: "Level 2",
      title: "Vowels",
      bgImageUrl: "assets/images/learningCardsBG/vowelsBG.png",
    ),
    LearningItem(
      level: "Level 3",
      title: "Opposite Words",
      bgImageUrl: "assets/images/learningCardsBG/oppositWordsBG.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.primaryAppColor,
      appBar: AppBar(
        backgroundColor: ColorRes.primaryAppColor,
        elevation: 0,
        title: const Text(
          constains.learningAppBarText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),

      /// 🔥 BODY
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// 🔥 ENTER CODE TILE
          _enterCodeTile(),

          const SizedBox(height: 20),

          /// 🔥 EXISTING LEARNING CARDS
          ...learningItems.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: LearningCard(
                item: item,
                onStartTap: () {
                  debugPrint("Start tapped: ${item.title}");
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  /// 🔥 ENTER CODE TILE UI
  Widget _enterCodeTile() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Enter Lesson Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              /// 🔤 INPUT FIELD
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
  controller: codeController,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    letterSpacing: 1.2, // 🔥 spacing for clarity
    fontFamily: 'monospace', // 🔥 IMPORTANT
  ),
  textCapitalization: TextCapitalization.characters, // optional
  decoration: const InputDecoration(
    hintText: "Enter code",
    hintStyle: TextStyle(color: Colors.white70),
    border: InputBorder.none,
  ),
),
                ),
              ),

              const SizedBox(width: 10),

              /// 🔥 SUBMIT BUTTON
              GestureDetector(
                onTap: () {
                  final code = codeController.text.trim();

                  if (code.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter a valid code")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Teacherlessonviewer(code: code),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorRes.primaryAppColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LessonViewerScreen extends StatelessWidget {
  final String code;

  const LessonViewerScreen({super.key, required this.code});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lesson")),
      body: Center(
        child: Text(
          "Code entered: $code",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}