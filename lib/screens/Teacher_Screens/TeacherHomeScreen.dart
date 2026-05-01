import 'package:flutter/material.dart';
import 'package:wordstudy_app/Models/TeacherDashboardModel.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/constants.dart';
import 'package:wordstudy_app/generalimports.dart';

class Teacherhomescreen extends StatefulWidget {
  const Teacherhomescreen({super.key});

  @override
  State<Teacherhomescreen> createState() => _TeacherhomescreenState();
}

class _TeacherhomescreenState extends State<Teacherhomescreen> {
  TeacherDashboardModel? data;
bool isLoading = true;
@override
void initState() {
  super.initState();
  loadDashboard();
}
Future<void> loadDashboard() async {
  try {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final firestore = FirebaseFirestore.instance;

    final teacherDoc =
        await firestore.collection("teachers").doc(uid).get();

    final teacherData = teacherDoc.data() ?? {};

    final lessonsSnap = await firestore
        .collection("teachers")
        .doc(uid)
        .collection("lessons")
        .get();

    final testsSnap = await firestore
        .collection("teachers")
        .doc(uid)
        .collection("tests")
        .get();

    final studentsSnap = await firestore
        .collection("teachers")
        .doc(uid)
        .collection("students")
        .get();

    if (!mounted) return; // 🔥 MUST be here (before setState)

    setState(() {
      data = TeacherDashboardModel(
        teacherName: teacherData['name'] ?? '',
        avatarUrl: teacherData['avatar'] ?? '',
        lessonsCount: lessonsSnap.docs.length,
        testsCount: testsSnap.docs.length,
        studentsCount: studentsSnap.docs.length,
        avgScore: 0,
      );
      isLoading = false;
    });

  } catch (e) {
    if (!mounted) return; // 🔥 ALSO here

    setState(() {
      isLoading = false;
    });
  }

}
  ///  Temporary dummy data (replace with API later)
  // final TeacherDashboardModel data = TeacherDashboardModel(
  //   teacherName: "Shivam Sir",
  //   avatarUrl: avatarImageTeacher,
  //   lessonsCount: 12,
  //   testsCount: 8,
  //   studentsCount: 45,
  //   avgScore: 76.5,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(data?.avatarUrl??""),
                    ),
                    const SizedBox(width: 16),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hi 👋",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          data?.teacherName??"",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 30),
                Expanded(
                  child: Column(
                    children: [

                      Row(
                        children: [
                          _statCard("Lessons", (data?.lessonsCount??"0").toString(), Icons.menu_book),
                          const SizedBox(width: 12),
                          _statCard("Tests", (data?.testsCount??"0").toString(), Icons.quiz),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _statCard("Students", (data?.studentsCount??"0").toString(), Icons.people),
                          const SizedBox(width: 12),
                          _statCard("Avg Score", "${data?.avgScore??0}%", Icons.bar_chart),
                        ],
                      ),

                      const SizedBox(height: 30),

                      _actionButton("Create Lesson", Icons.add_box, () {}),
                      const SizedBox(height: 12),

                      _actionButton("Create Test", Icons.edit, () {}),
                      const SizedBox(height: 12),

                      _actionButton("View Results", Icons.analytics, () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 📦 STAT CARD
  Widget _statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.yellow, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔘 ACTION BUTTON
  Widget _actionButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: ColorRes.primaryAppColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}