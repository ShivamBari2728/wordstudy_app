import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/LearningScreen/learningScreen.dart';
import 'package:wordstudy_app/screens/PracticeScreen/PracticeHomeScreen.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherHomeScreen.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherLessionsScreen.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherProfileScreen.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherStudentsScreen.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherTestScreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int selectedIndex = 0;
  String userRole = "student";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await SessionManager.getUserRole();
    if (!mounted) return;

    setState(() {
      userRole = role ?? "student";
      selectedIndex = 0; // ✅ prevent index mismatch
      isLoading = false;
    });
  }

  /// 🔥 Role-based screens
  List<Widget> get _screens {
    if (userRole == "teacher") {
      return const [
        Teacherhomescreen(),
        Teacherlessionsscreen(),
        Teachertestscreen(),
        Teacherstudentsscreen(),
        Teacherprofilescreen(),
      ];
    } else {
      return const [
        Homescreen(),
        LearningScreen(),
        PracticeHomeScreen(),
      ];
    }
  }

  /// 🔥 Role-based nav items
  List<Widget> get _navItems {
    if (userRole == "teacher") {
      return [
        _navIcon('assets/icons/navbaricons/homeicon.svg'),
        _navIcon('assets/icons/navbaricons/bookicon.svg'),
        _navIcon('assets/icons/navbaricons/testicon.svg'),
        _navIcon('assets/icons/navbaricons/studenticon.svg'),
        _navIcon('assets/icons/navbaricons/profileicon.svg'),
      ];
    } else {
      return [
        _navIcon('assets/icons/homeicon.svg'),
        _navIcon('assets/icons/bookicon.svg'),
        _navIcon('assets/icons/testicon.svg'),
      ];
    }
  }

  Widget _navIcon(String path) {
    return SvgPicture.asset(
      path,
      width: 30,
      height: 30,
      colorFilter: ColorFilter.mode(
        ColorRes.primaryAppColor,
        BlendMode.srcIn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// ⏳ Loading state (prevents crash)
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screens = _screens;
    final navItems = _navItems;

    /// 🔒 Safe index handling
    final safeIndex =
        selectedIndex < screens.length ? selectedIndex : 0;

    return Scaffold(
      body: screens[safeIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: ColorRes.primaryAppColor,
        color: ColorRes.SecondryAppColor,
        height: 60,
        animationDuration: const Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: safeIndex,

        items: navItems,

        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}