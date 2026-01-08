import 'package:flutter/material.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/screens/PracticeScreen/PracticeSubjectUI/OppositeWordsPracticeScreen.dart';
import 'package:wordstudy_app/screens/PracticeScreen/PracticeSubjectUI/VowelPractice.dart';

class PracticeCard extends StatelessWidget {
  final String level;
  final String title;
  final String bgImageUrl;
  final double progress; 

  const PracticeCard({
    super.key,
    required this.level,
    required this.title,
    required this.bgImageUrl,
    required this.progress,
  });

  /// 🔹 Decide practice screen
  Widget _getPracticeScreen() {
    switch (title.toLowerCase()) {
      case "vowels practice":
      case "vowels":
        return const VowelsPracticeScreen();

      case "opposite words practice":
      case "opposite words":
        return const OppositeWordsPracticeScreen();

      default:
        return const VowelsPracticeScreen();
    }
  }

  /// 🔹 Description
  String _getDescription() {
    switch (title.toLowerCase()) {
      case "vowels practice":
        return "Choose A or AN correctly";
      case "opposite words practice":
        return "Choose the opposite word";
      default:
        return "Practice and have fun!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 180, // increased for progress bar
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(bgImageUrl),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.35),
                BlendMode.darken,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 TITLE
              Text(
                "$level: $title",
                style: const TextStyle(
                  fontSize: 22,
                  //fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 6),

              /// 🔹 DESCRIPTION
              Text(
                _getDescription(),
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white70,
                ),
              ),

              const SizedBox(height: 12),

              /// 🔹 PROGRESS BAR (Responsive)
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0
                              ? Colors.greenAccent
                              : ColorRes.primaryAppColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              /// 🔘 PRACTICE BUTTON
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primaryAppColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _getPracticeScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "PRACTICE",
                    style: TextStyle(
                      fontSize: 19,
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
