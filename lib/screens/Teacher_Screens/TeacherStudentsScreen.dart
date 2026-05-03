import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class Teacherstudentsscreen extends StatefulWidget {
  const Teacherstudentsscreen({super.key});

  @override
  State<Teacherstudentsscreen> createState() =>
      _TeacherstudentsscreenState();
}

class _TeacherstudentsscreenState extends State<Teacherstudentsscreen> {
  List<Map<String, dynamic>> results = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("test_results")
          .orderBy("timestamp", descending: true)
          .get();

      if (!mounted) return;

      setState(() {
        results = snapshot.docs.map((doc) => doc.data()).toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/SimpleWordsBGImage.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.45),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  const Text(
                    "Student Results",
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
                  else if (results.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Text(
                          "No students attempted yet",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final data = results[index];

                          final score = data["score"] ?? 0;
                          final total = data["total"] ?? 1;

                          final percent =
                              ((score / total) * 100).toStringAsFixed(1);

                          final testTitle =
                              data["testTitle"] ?? "Test";

                          return _resultCard(
                            name: data["studentName"] ?? "Unknown",
                            grade: data["studentGrade"] ?? "",
                            testTitle: testTitle,
                            score: "$score / $total",
                            percent: "$percent%",
                          );
                        },
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

  Widget _resultCard({
    required String name,
    required String grade,
    required String testTitle,
    required String score,
    required String percent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [

          const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(
                  "Grade $grade",
                  style: const TextStyle(color: Colors.white70),
                ),

                Text(
                  "Test: $testTitle",
                  style: const TextStyle(color: Colors.white54),
                ),
              ],
            ),
          ),


          Column(
            children: [
              Text(
                percent,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                score,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}