import 'package:flutter/material.dart';
import 'package:wordstudy_app/generalimports.dart';

class Testhomescreen extends StatefulWidget {
  const Testhomescreen({super.key});

  @override
  State<Testhomescreen> createState() => _TesthomescreenState();
}

class _TesthomescreenState extends State<Testhomescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.primaryAppColor,
    );
  }
}