class TeacherDashboardModel {
  final String teacherName;
  final String avatarUrl;
  final int lessonsCount;
  final int testsCount;
  final int studentsCount;
  final double avgScore;

  TeacherDashboardModel({
    required this.teacherName,
    required this.avatarUrl,
    required this.lessonsCount,
    required this.testsCount,
    required this.studentsCount,
    required this.avgScore,
  });

  factory TeacherDashboardModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardModel(
      teacherName: json['teacher_name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      lessonsCount: json['lessons_count'] ?? 0,
      testsCount: json['tests_count'] ?? 0,
      studentsCount: json['students_count'] ?? 0,
      avgScore: (json['avg_score'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'teacher_name': teacherName,
      'avatar_url': avatarUrl,
      'lessons_count': lessonsCount,
      'tests_count': testsCount,
      'students_count': studentsCount,
      'avg_score': avgScore,
    };
  }
}