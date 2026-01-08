import 'package:wordstudy_app/colors/colorRes.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/LearningScreen/learningScreen.dart';
import 'package:wordstudy_app/screens/PracticeScreen/PracticeHomeScreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    const Homescreen(),
    const LearningScreen(),
    const PracticeHomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
  backgroundColor: ColorRes.primaryAppColor,
  color:ColorRes.SecondryAppColor,
  height: 60,
  animationDuration: const Duration(milliseconds: 300),
  animationCurve: Curves.easeInOut,
  index: selectedIndex,

  items: [
    SvgPicture.asset(
      'assets/icons/homeicon.svg',
      width: 30,
      height: 30,
      colorFilter: ColorFilter.mode(
        selectedIndex == 0 ? ColorRes.primaryAppColor : ColorRes.primaryAppColor,
        BlendMode.srcIn,
      ),
    ),
    SvgPicture.asset(
      'assets/icons/bookicon.svg',
      width: 30,
      height: 30,
      colorFilter: ColorFilter.mode(
        selectedIndex == 1 ? ColorRes.primaryAppColor : ColorRes.primaryAppColor,
        BlendMode.srcIn,
      ),
    ),
    SvgPicture.asset(
      'assets/icons/testicon.svg',
      width: 30,
      height: 30,
      colorFilter: ColorFilter.mode(
        selectedIndex == 2 ? ColorRes.primaryAppColor : ColorRes.primaryAppColor,
        BlendMode.srcIn,
      ),
    ),
  ],

  onTap: (index) {
    setState(() {
      selectedIndex = index;
    });
  },
)

    );
  }
}
