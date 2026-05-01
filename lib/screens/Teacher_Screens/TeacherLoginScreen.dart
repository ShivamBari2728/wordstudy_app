import 'package:flutter/material.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/mainscreen.dart';

class TeacherLoginScreen extends StatefulWidget {
  const TeacherLoginScreen({super.key});

  @override
  State<TeacherLoginScreen> createState() => _TeacherLoginScreenState();
}

class _TeacherLoginScreenState extends State<TeacherLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  String? errorText;

  /// 🔐 TEMP LOGIN (replace later with Firebase)
  Future<bool> _login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email == "admin" && password == "admin") {
      await SessionManager.setUserRole("teacher");
      return true;
    }
    return false;
  }

  void _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      isLoading = true;
      errorText = null;
    });

    final success = await _login(email, password);

    setState(() {
      isLoading = false;
    });

    if (success) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Mainscreen()),
      );
    } else {
      setState(() {
        errorText = "Invalid email or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
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
                          const SizedBox(height: 40),
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(avatarImageTeacher),
                            // onBackgroundImageError: (_, __) {},
                            // child: const Icon(
                            //   Icons.person,
                            //   size: 40,
                            //   color: Colors.grey,
                            // ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Teacher Login",
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 40),

                          /// 📧 EMAIL
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter email",
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: Colors.yellow,
                              fontSize: 20,
                            ),
                            decoration: InputDecoration(
                              hintText: "Enter password",
                              hintStyle: const TextStyle(color: Colors.white70),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// ❌ ERROR
                          if (errorText != null)
                            Text(
                              errorText!,
                              style: const TextStyle(color: Colors.redAccent),
                            ),

                          const SizedBox(height: 30),

                          /// 👉 LOGIN BUTTON
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorRes.primaryAppColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: isLoading ? null : _handleLogin,
                            child: isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),

                          const SizedBox(height: 40),

                          /// 🔙 BACK
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Back to Student",
                              style: TextStyle(
                                color: Colors.yellow,
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
}
