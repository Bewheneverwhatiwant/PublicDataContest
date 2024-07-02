import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class AllPage extends StatelessWidget {
  const AllPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '전체 멘토링',
      ),
      body: Center(
        child: Text('여기는 전체~~~'),
      ),
    );
  }
}
