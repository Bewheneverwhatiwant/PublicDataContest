import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class OtherPage extends StatelessWidget {
  const OtherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '기타 멘토링',
      ),
      body: Center(
        child: Text('기타~~~'),
      ),
    );
  }
}
