import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wordstudy_app/firebase_options.dart';
import 'package:wordstudy_app/screens/mainscreen.dart';
import 'package:wordstudy_app/generalimports.dart';
import 'package:wordstudy_app/screens/signUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

    runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PracticeProgressProvider()..loadProgress(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Bangers"
      ),
      home: const StudentSetupScreen(),
    );
  }
}
