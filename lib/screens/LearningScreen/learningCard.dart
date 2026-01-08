import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/LearningScreen/LearningDetailScreen.dart';

class LearningCard extends StatefulWidget {
  final LearningItem item;
  final VoidCallback onStartTap;

  const LearningCard({
    super.key,
    required this.item,
    required this.onStartTap,
  });

  @override
  State<LearningCard> createState() => _LearningCardState();
}

class _LearningCardState extends State<LearningCard> {

  /// 🔹 Decide subject based on title
  LearningSubjectType _getSubjectType() {
    switch (widget.item.title.toLowerCase()) {
      case "simple words":
        return LearningSubjectType.simpleWords;
      case "vowels":
        return LearningSubjectType.vowels;
      case "opposite words":
        return LearningSubjectType.oppositeWords;
      default:
        return LearningSubjectType.simpleWords; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(widget.item.bgImageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.item.level}: ${widget.item.title}",
            style: const TextStyle(
              fontSize: 22,
              //fontWeight: FontWeight.w700,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black54,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.item.showStart)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primaryAppColor,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: Colors.black54,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LearningDetailScreen(
                          subjectType: _getSubjectType(),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "START",
                    style: TextStyle(
                      fontSize: 20,
                      //fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
