
import 'package:wordstudy_app/constants.dart' as constains;
import 'package:wordstudy_app/screens/PracticeScreen/PracticeCards.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/PracticeScreen/TeacherTestViewer/TeacherQuestionViewer.dart';
class PracticeHomeScreen extends StatefulWidget {
  const PracticeHomeScreen({super.key});

  @override
  State<PracticeHomeScreen> createState() => _PracticeHomeScreenState();
}

class _PracticeHomeScreenState extends State<PracticeHomeScreen> {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<PracticeProgressProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.primaryAppColor,
        elevation: 0,
        title: const Text(
          constains.PracticeAppBarText,
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
      ),

      body: Container(
        color: ColorRes.primaryAppColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [

            /// 🔥 ENTER TEST CODE CARD
            _enterTestCodeCard(),

            const SizedBox(height: 20),

            /// EXISTING CARDS
            PracticeCard(
              level: "Level 1",
              title: "Vowels Practice",
              bgImageUrl: "assets/images/SimpleWordsBGImage.png",
              progress: progress.vowelsProgress,
            ),

            const SizedBox(height: 16),

            PracticeCard(
              level: "Level 2",
              title: "Opposite Words Practice",
              bgImageUrl: "assets/images/SimpleWordsBGImage.png",
              progress: progress.oppositesProgress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _enterTestCodeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Enter Test Code",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: codeController,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Enter test code",
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              GestureDetector(
                onTap: () {
                  final code = codeController.text.trim();
                  if (code.isEmpty) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Teacherquestionsviewer(code: code),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorRes.primaryAppColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}