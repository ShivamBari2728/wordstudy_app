import 'package:flutter/material.dart';
import 'package:wordstudy_app/Models/oppositeWordsModel.dart';
import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/services/opposite_words_service.dart';

class OppositeWordsScreen extends StatefulWidget {
  final VoidCallback onFinished;

  const OppositeWordsScreen({
    super.key,
    required this.onFinished,
  });

  @override
  State<OppositeWordsScreen> createState() => _OppositeWordsScreenState();
}

class _OppositeWordsScreenState extends State<OppositeWordsScreen> {
  final PageController _pageController = PageController();
  final OppositeWordsService _service = OppositeWordsService();

  int currentPage = 0;
  bool isLoading = true;

  List<OppositeWord> _opposites = [];

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _loadOpposites();
  }

  Future<void> _loadOpposites() async {
    _opposites = await _service.fetchOppositeWords();

    _pages = [
      const _OppositeIntroPage(),
      ..._opposites.map(
        (item) => _OppositeImageCard(
          leftWord: item.leftWord,
          rightWord: item.rightWord,
          leftImage: item.leftImage,
          rightImage: item.rightImage,
        ),
      ),
    ];

    setState(() => isLoading = false);
  }

  void _nextPage() {
    if (currentPage < _pages.length - 1) {
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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() => currentPage = index);
                  },
                  children: _pages,
                ),
              ),
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


/// ================= INTRO PAGE =================
class _OppositeIntroPage extends StatelessWidget {
  const _OppositeIntroPage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "OPPOSITE WORDS",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Text(
              "Opposite words\nhave different meanings",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "BIG  ↔  SMALL\nHOT  ↔  COLD",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Swipe to learn",
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ================= IMAGE CARD =================
class _OppositeImageCard extends StatelessWidget {
  final String leftWord;
  final String rightWord;
  final String leftImage;
  final String rightImage;

  const _OppositeImageCard({
    required this.leftWord,
    required this.rightWord,
    required this.leftImage,
    required this.rightImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _imageBox(leftImage, leftWord),
              const Icon(
                Icons.compare_arrows,
                size: 40,
                color: Colors.white,
              ),
              _imageBox(rightImage, rightWord),
            ],
          ),
        ],
      ),
    );
  }

  Widget _imageBox(String imageUrl, String word) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            height: 160,
            width: 160,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          word,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
