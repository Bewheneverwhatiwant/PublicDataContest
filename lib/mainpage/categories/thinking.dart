import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class ThinkingPage extends StatelessWidget {
  const ThinkingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '기획 멘토링',
      ),
      body: Center(
        child: Text('기획 기획'),
      ),
    );
  }
}
