import 'package:flamingo/widget/text/text.dart';
import 'package:flutter/material.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget('Me'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
