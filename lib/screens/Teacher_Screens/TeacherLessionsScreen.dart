import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/CreateLessionScreen.dart';

class Teacherlessionsscreen extends StatefulWidget {
  const Teacherlessionsscreen({super.key});

  @override
  State<Teacherlessionsscreen> createState() => _TeacherlessionsscreenState();
}

class _TeacherlessionsscreenState extends State<Teacherlessionsscreen> {
  List<Map<String, dynamic>> lessons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLessons();
  }

  /// 🔥 Fetch lessons
  Future<void> fetchLessons() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .collection("lessons")
          .orderBy("created_at", descending: true)
          .get();

      final fetchedLessons = snapshot.docs.map((doc) {
        final data = doc.data();
        return {"id": doc.id, "title": data["title"] ?? "Untitled Lesson"};
      }).toList();

      if (!mounted) return;

      setState(() {
        lessons = fetchedLessons;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  /// 🗑 DELETE LESSON
  Future<void> deleteLesson(String lessonId) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(uid)
        .collection("lessons")
        .doc(lessonId)
        .delete();

    fetchLessons(); // 🔥 refresh UI
  }

  /// ⚠️ CONFIRM DELETE POPUP
  void showDeleteDialog(String lessonId) {
    showDialog(
      context: context,
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
                  "Delete Lesson?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  "This action cannot be undone",
                  style: TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    /// Cancel
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Delete
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);

                          final scaffoldMessenger = ScaffoldMessenger.of(
                            this.context,
                          );

                          await deleteLesson(lessonId);

                          scaffoldMessenger.showSnackBar(
                            const SnackBar(content: Text("Lesson deleted")),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Delete",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "Your Lessons",
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                if (isLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (lessons.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        "You haven't created any lessons yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchLessons,
                      child: ListView.builder(
                        itemCount: lessons.length,
                        itemBuilder: (context, index) {
                          final lesson = lessons[index];
                      
                          return _lessonCard(lesson["title"], lesson["id"]);
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ColorRes.primaryAppColor,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Createlessionscreen()),
          );
          fetchLessons();
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create Lesson",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  /// 📦 LESSON CARD
  Widget _lessonCard(String title, String lessonId) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu_book, color: Colors.yellow, size: 28),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  "Code: $lessonId",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          /// COPY
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: lessonId));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Copied")));
            },
            child: const Icon(Icons.copy, color: Colors.white70),
          ),

          const SizedBox(width: 12),

          /// 🗑 DELETE
          GestureDetector(
            onTap: () => showDeleteDialog(lessonId),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
