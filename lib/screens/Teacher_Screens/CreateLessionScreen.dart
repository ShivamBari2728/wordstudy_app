import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class Createlessionscreen extends StatefulWidget {
  const Createlessionscreen({super.key});

  @override
  State<Createlessionscreen> createState() =>
      _CreatelessionscreenState();
}

class _CreatelessionscreenState extends State<Createlessionscreen> {

  int step = 0;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController gradeController = TextEditingController();

  List<Map<String, TextEditingController>> slides = [
    {
      "text": TextEditingController(),
      "image": TextEditingController(),
    }
  ];

  bool isLoading = false;

  void addSlide() {
    setState(() {
      slides.add({
        "text": TextEditingController(),
        "image": TextEditingController(),
      });
    });
  }

  void removeSlide(int index) {
    if (slides.length == 1) return;

    setState(() {
      slides.removeAt(index);
    });
  }

Future<void> saveLesson() async {
  final title = titleController.text.trim();
  final grade = gradeController.text.trim();

  if (title.isEmpty || grade.isEmpty) return;

  final slideData = slides.map((s) {
    return {
      "text": s["text"]!.text.trim(),
      "imageUrl": s["image"]!.text.trim(),
    };
  }).where((s) => s["text"]!.isNotEmpty).toList();

  if (slideData.isEmpty) return;

  setState(() => isLoading = true);

  try {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final docRef = await FirebaseFirestore.instance
        .collection("teachers")
        .doc(uid)
        .collection("lessons")
        .add({
      "title": title,
      "grade": grade,
      "slides": slideData,
      "created_at": FieldValue.serverTimestamp(),
    });

    final lessonId = docRef.id;

    if (!mounted) return;

    setState(() => isLoading = false);

    showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
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
              "Lesson Created 🎉",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Share this code with students",
              style: TextStyle(
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                lessonId,
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
                      Clipboard.setData(
                        ClipboardData(text: lessonId),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Copied to clipboard"),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Copy",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: ColorRes.primaryAppColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Done",
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

  } catch (e) {
    print(e);

    if (!mounted) return;

    setState(() => isLoading = false);
  }
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
            child: step == 0 ? _buildStepOne() : _buildSlides(),
          ),
        ),
      ),
    );
  }

  Widget _buildStepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Create Lesson",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 20),

        _glassField(titleController, "Lesson Title"),
        const SizedBox(height: 16),
        _glassField(gradeController, "Grade"),

        const Spacer(),

        _primaryButton("Next", () {
          if (titleController.text.isEmpty ||
              gradeController.text.isEmpty) return;

          setState(() => step = 1);
        }),
      ],
    );
  }

  Widget _buildSlides() {
    return Column(
      children: [

        const Text(
          "Slides",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Expanded(
          child: ListView.builder(
            itemCount: slides.length,
            itemBuilder: (context, index) {
              final slide = slides[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Slide ${index + 1}",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    _glassField(slide["text"]!, "Enter text"),

                    const SizedBox(height: 10),

                    _glassField(slide["image"]!, "Image URL (optional)"),

                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => removeSlide(index),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: _secondaryButton("Add Slide", addSlide),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _primaryButton(
                "Finish",
                isLoading ? null : saveLesson,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _glassField(TextEditingController controller, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
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

  Widget _primaryButton(String text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: ColorRes.primaryAppColor,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _secondaryButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}