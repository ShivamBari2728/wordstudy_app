import 'package:flutter/material.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/LearningScreen/learningCard.dart';
import 'package:wordstudy_app/constants.dart' as constains;


class LearningScreen extends StatefulWidget {
  const LearningScreen({super.key});

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {

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
    //showStart: true,
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
        //leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          constains.learningAppBarText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30
            //fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: learningItems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: LearningCard(
              item: learningItems[index],
              onStartTap: () {
                // Handle start click per level
                debugPrint("Start tapped: ${learningItems[index].title}");
              },
            ),
          );
        },
      ),
    );
  }
}
