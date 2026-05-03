import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/CreateTestScreen.dart';

class Teachertestscreen extends StatefulWidget {
  const Teachertestscreen({super.key});

  @override
  State<Teachertestscreen> createState() => _TeachertestscreenState();
}

class _TeachertestscreenState extends State<Teachertestscreen> {
  List<Map<String, dynamic>> tests = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTests();
  }

  Future<void> fetchTests() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final snapshot = await FirebaseFirestore.instance
          .collection("teachers")
          .doc(uid)
          .collection("tests")
          .orderBy("created_at", descending: true)
          .get();

      final fetched = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          "title": data["title"] ?? "Untitled Test",
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        tests = fetched;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteTest(String id) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("teachers")
        .doc(uid)
        .collection("tests")
        .doc(id)
        .delete();

    fetchTests();
  }

  void showDeleteDialog(String id) {
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
                  "Delete Test?",
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
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: _btn("Cancel", Colors.white.withOpacity(0.2)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pop(context);

                          final messenger =
                              ScaffoldMessenger.of(this.context);

                          await deleteTest(id);

                          messenger.showSnackBar(
                            const SnackBar(content: Text("Test deleted")),
                          );
                        },
                        child: _btn("Delete", Colors.red),
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
                  "Your Tests",
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
                else if (tests.isEmpty)
                  Expanded(
                    child: Center(
                      child: const Text(
                        "You haven't created any tests yet",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: fetchTests,
                      child: ListView.builder(
                        itemCount: tests.length,
                        itemBuilder: (context, index) {
                          final test = tests[index];
                          return _card(test["title"], test["id"]);
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
          
          await Navigator.push(context,
            MaterialPageRoute(builder: (_) => const Createtestscreen()));

          fetchTests();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "Create Test",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget _card(String title, String id) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.quiz, color: Colors.yellow, size: 28),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 18)),
                const SizedBox(height: 4),
                Text("Code: $id",
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: id));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Copied")),
              );
            },
            child: const Icon(Icons.copy, color: Colors.white70),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            onTap: () => showDeleteDialog(id),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
    );
  }
}