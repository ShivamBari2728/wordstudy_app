import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class Teacherlessonviewer extends StatefulWidget {
  final String code;

  const Teacherlessonviewer({super.key, required this.code});

  @override
  State<Teacherlessonviewer> createState() =>
      _TeacherlessonviewerState();
}

class _TeacherlessonviewerState extends State<Teacherlessonviewer> {
  final PageController _pageController = PageController();

  List slides = [];
  int currentPage = 0;
  bool isLoading = true;
  String title = "";

  @override
  void initState() {
    super.initState();
    fetchLesson();
  }

  /// 🔥 FETCH LESSON
  Future<void> fetchLesson() async {
    try {
      final teachers =
          await FirebaseFirestore.instance.collection("teachers").get();

      for (var teacher in teachers.docs) {
        final doc = await teacher.reference
            .collection("lessons")
            .doc(widget.code)
            .get();

        if (doc.exists) {
          final data = doc.data()!;

          if (!mounted) return;

          setState(() {
            slides = data["slides"] ?? [];
            title = data["title"] ?? "";
            isLoading = false;
          });

          return;
        }
      }

      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lesson not found")),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void _nextPage() {
    if (currentPage < slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
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
          color: Colors.black.withOpacity(0.25),
          child: SafeArea(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())

                : slides.isEmpty
                    ? const Center(
                        child: Text(
                          "No slides available",
                          style: TextStyle(color: Colors.white),
                        ),
                      )

                    : Column(
                        children: [

                          /// 🔥 PAGE VIEW (same as vowels screen)
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              physics:
                                  const BouncingScrollPhysics(),
                              onPageChanged: (index) {
                                setState(() => currentPage = index);
                              },
                              itemCount: slides.length,
                              itemBuilder: (context, index) {
                                return _buildSlide(slides[index]);
                              },
                            ),
                          ),

                          /// 🔘 CONTINUE BUTTON (same style)
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 24),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    ColorRes.primaryAppColor,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 60,
                                  vertical: 16,
                                ),
                              ),
                              onPressed: _nextPage,
                              child: Text(
                                currentPage ==
                                        slides.length - 1
                                    ? "FINISH"
                                    : "CONTINUE",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      ),
    );
  }

  /// 🔥 SLIDE UI (MATCHED STYLE)
Widget _buildSlide(Map slide) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12), // 🔥 glass effect
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔤 TEXT
                Text(
                  slide["text"] ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: "Roboto",
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 20),

                /// 🖼 IMAGE (optional)
                if (slide["imageUrl"] != null &&
                    slide["imageUrl"].toString().isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      slide["imageUrl"],
                      height: 220,
                      fit: BoxFit.cover,
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
}