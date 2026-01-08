import 'package:flutter/material.dart';
import 'package:wordstudy_app/constants.dart' as constains;
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/LearningScreen/learningScreen.dart';
import 'package:wordstudy_app/screens/PracticeScreen/PracticeHomeScreen.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  String studentName = "";
  String studentGrade = "";

  @override
  void initState() {
    super.initState();
    _loadStudentData();
  }

  Future<void> _loadStudentData() async {
    final name = await SessionManager.getStudentName();
    final grade = await SessionManager.getStudentGrade();

    if (!mounted) return;

    setState(() {
      studentName = name!;
      studentGrade = grade!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.primaryAppColor, // your app background color

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------------- PROFILE SECTION ----------------
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),

                child: Container(
                  color: ColorRes.nameBarColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        FutureBuilder<String>(
                          future: SessionManager.getStudentGender(),
                          builder: (context, snapshot) {
                            final gender = snapshot.data ?? "boy";

                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                gender == "girl"
                                    ? constains.avaterImageGirl
                                    : constains.avaterImageBoy,
                              ),
                            );
                          },
                        ),

                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              studentName.isEmpty ? "Hi!" : "Hi, $studentName!",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              studentGrade.isEmpty ? "" : "Grade $studentGrade",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// ---------------- STATS SECTION ----------------
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.menu_book_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "22 Words\nLearned",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 30),
                          const SizedBox(height: 6),
                          const Text(
                            "Stars Earned\n8",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              height: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// ---------------- MENU BUTTONS ----------------
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LearningScreen()),
                  );
                },

                child: _menuButton(
                  icon: Icons.lightbulb_outline,
                  text: "Continue Learning",
                  bgColor: Colors.lightBlueAccent.shade100,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PracticeHomeScreen(),
                    ),
                  );
                },

                child: _menuButton(
                  icon: Icons.check_circle_outline,
                  text: "Take a Test",
                  bgColor: const Color.fromARGB(255, 120, 255, 133),
                ),
              ),
              InkWell(
                //  onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => const Homescreen()),
                //   );
                // },
                child: _menuButton(
                  icon: Icons.sports_esports,
                  text: "Play a Game",
                  bgColor: Colors.orangeAccent.shade100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------------- REUSABLE MENU BUTTON WIDGET ----------------
  Widget _menuButton({
    required IconData icon,
    required String text,
    required Color bgColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 26, color: Colors.white),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              //fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
