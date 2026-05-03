
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/mainscreen.dart';
import 'package:wordstudy_app/screens/Teacher_Screens/TeacherLoginScreen.dart';
import 'package:wordstudy_app/screens/signUpScreen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  @override
  State<StartupScreen> createState() => _StartupScreenState();
}

class _StartupScreenState extends State<StartupScreen> {

  @override
  void initState() {
    super.initState();
    _decideRoute();
  }

  Future<void> _decideRoute() async {
    final user = FirebaseAuth.instance.currentUser;
    final role = await SessionManager.getUserRole();
    final isProfileCreated = await SessionManager.isProfileCreated();

    Widget nextScreen;

    if (user != null && role == "teacher") {
      nextScreen = const Mainscreen();
    }

    else if (role == "student" && isProfileCreated) {
      nextScreen = const Mainscreen();
    }

    else {
      nextScreen = const StudentSetupScreen();
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}