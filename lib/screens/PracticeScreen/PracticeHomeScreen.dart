
import 'package:wordstudy_app/constants.dart' as constains;
import 'package:wordstudy_app/screens/PracticeScreen/PracticeCards.dart';
import 'package:wordstudy_app/generalimports.dart';

class PracticeHomeScreen extends StatelessWidget {
  const PracticeHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<PracticeProgressProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.primaryAppColor,
        elevation: 0,
        //leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          constains.PracticeAppBarText,
          style: TextStyle(
            color: Colors.white,
             fontSize: 30
            //fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: ColorRes.primaryAppColor,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
}
