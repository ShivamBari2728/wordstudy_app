class LearningItem {
  final String level;
  final String title;
  final String bgImageUrl;
  final bool showStart;

  LearningItem({
    required this.level,
    required this.title,
    required this.bgImageUrl,
    this.showStart = true,
  });
}
