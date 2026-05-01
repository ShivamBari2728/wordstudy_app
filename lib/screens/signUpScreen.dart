import 'package:flutter/material.dart';
import 'package:wordstudy_app/constants.dart' as constains;
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherLoginScreen.dart';
import 'package:wordstudy_app/screens/mainscreen.dart';

class StudentSetupScreen extends StatefulWidget {
  const StudentSetupScreen({super.key});

  @override
  State<StudentSetupScreen> createState() => _StudentSetupScreenState();
}

class _StudentSetupScreenState extends State<StudentSetupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gradeController = TextEditingController();

  String selectedGender = "boy";

  @override
  void initState() {
    super.initState();
    _checkIfAlreadySignedIn();
  }

  Future<void> _checkIfAlreadySignedIn() async {
    final isCreated = await SessionManager.isProfileCreated();
    if (isCreated) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Mainscreen()),
      );
    }
  }

  void _continue() async {
    final name = _nameController.text.trim();
    final grade = _gradeController.text.trim();

    if (name.isEmpty || grade.isEmpty) return;

    await SessionManager.setStudentName(name);
    await SessionManager.setStudentGrade(grade);
    await SessionManager.setStudentGender(selectedGender);
    await SessionManager.setProfileCreated(true);
    await SessionManager.setUserRole("student");

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const Mainscreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            //physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage(
                      "assets/images/SimpleWordsBGImage.png",
                    ),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.45),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),

                          /// 👦👧 AVATARS
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _genderAvatar(
                                gender: "boy",
                                imageUrl: constains.avaterImageBoy,
                              ),
                              const SizedBox(width: 24),
                              _genderAvatar(
                                gender: "girl",
                                imageUrl: constains.avaterImageGirl,
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          const Text(
                            "Welcome!",
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 👦👧 GENDER DROPDOWN
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButton<String>(
                              value: selectedGender,
                              isExpanded: true,
                              underline: const SizedBox(),
                              dropdownColor: Colors.yellow,
                              iconEnabledColor: Colors.white,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "boy",
                                  child: Text("Boy"),
                                ),
                                DropdownMenuItem(
                                  value: "girl",
                                  child: Text("Girl"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value!;
                                });
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// 👶 NAME
                          TextField(
                            controller: _nameController,
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// 🎓 GRADE
                          TextField(
                            controller: _gradeController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 22,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 18,
                              ),
                              hintText: "Enter your grade (e.g. 1, 2, 3)",
                              hintStyle: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          /// 👉 CONTINUE
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.primaryAppColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: _continue,
                            child: const Text(
                              "CONTINUE",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                         const SizedBox(height: 40),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                 MaterialPageRoute(builder: (_) => const TeacherLoginScreen()),
                              );
                            },
                            child: const Text(
                              "Login as Teacher?",
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 👦👧 GENDER AVATAR WIDGET
  Widget _genderAvatar({required String gender, required String imageUrl}) {
    final bool isSelected = selectedGender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedGender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Column(
          children: [
            CircleAvatar(
              radius: isSelected ? 50 : 32,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(imageUrl),
            ),
            const SizedBox(height: 6),
            Text(
              gender == "boy" ? "Boy" : "Girl",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSelected ? 16 : 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
