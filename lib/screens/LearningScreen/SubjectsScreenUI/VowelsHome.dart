import 'package:flutter/material.dart';
import 'package:wordstudy_app/colors/colorRes.dart';

class VowelsIntroScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const VowelsIntroScreen({
    super.key,
    required this.onFinished,
  });

  @override
  State<VowelsIntroScreen> createState() => _VowelsIntroScreenState();
}

class _VowelsIntroScreenState extends State<VowelsIntroScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  void _nextPage() {
    if (currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinished();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/SimpleWordsBGImage.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.25),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  // ✅ swipe enabled
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  children: const [
                    _VowelDefinitionPage(),
                    _ConsonantDefinitionPage(),
                    _AEIOUPage(),
                    _AAnExamplesPageOne(),
                    _AAnExamplesPageTwo(),
                  ],
                ),
              ),

              /// 🔘 CONTINUE BUTTON (same design)
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primaryAppColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 16,
                    ),
                  ),
                  onPressed: _nextPage,
                  child: const Text(
                    "CONTINUE",
                    style: TextStyle(
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
    );
  }
}

/// ================= PAGE 1 =================
class _VowelDefinitionPage extends StatelessWidget {
  const _VowelDefinitionPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "VOWELS",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Letters that help us\nmake sounds",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
          SizedBox(height: 30),
          Text(
            "A  E  I  O  U",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PAGE 2 =================
class _ConsonantDefinitionPage extends StatelessWidget {
  const _ConsonantDefinitionPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "CONSONANTS",
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "All letters\nexcept vowels",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, color: Colors.white),
          ),
          SizedBox(height: 30),
          Text(
            "B  C  D  F  G  ...  Z",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.lightBlueAccent,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PAGE 3 =================
class _AEIOUPage extends StatelessWidget {
  const _AEIOUPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "VOWELS",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          Text(
            "A   E   I   O   U",
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Swipe to see examples",
            style: TextStyle(
              fontSize: 22,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// ================= PAGE 4 =================
class _AAnExamplesPageOne extends StatelessWidget {
  const _AAnExamplesPageOne();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Use AN",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          Text("An Apple 🍎", style: _exampleStyle),
          SizedBox(height: 12),
          Text("An Elephant 🐘", style: _exampleStyle),
          SizedBox(height: 12),
          Text("An Ice Cream 🍦", style: _exampleStyle),
          SizedBox(height: 12),
          Text("An Orange 🍊", style: _exampleStyle),
        ],
      ),
    );
  }
}

/// ================= PAGE 5 =================
class _AAnExamplesPageTwo extends StatelessWidget {
  const _AAnExamplesPageTwo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            "Use A",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),
          Text("A Ball ⚽", style: _exampleStyle),
          SizedBox(height: 12),
          Text("A Cat 🐱", style: _exampleStyle),
          SizedBox(height: 12),
          Text("A Dog 🐶", style: _exampleStyle),
          SizedBox(height: 12),
          Text("A Sun ☀️", style: _exampleStyle),
        ],
      ),
    );
  }
}

/// 🔹 shared style
const TextStyle _exampleStyle = TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.bold,
  color: Colors.yellow,
);
