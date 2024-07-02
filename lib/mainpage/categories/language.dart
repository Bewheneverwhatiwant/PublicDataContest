import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '언어 멘토링',
      ),
      body: Center(
        child: Text('언어~~~'),
      ),
    );
  }
}
