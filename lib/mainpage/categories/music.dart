import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '음악 멘토링',
      ),
      body: Center(
        child: Text('음악~~~'),
      ),
    );
  }
}
