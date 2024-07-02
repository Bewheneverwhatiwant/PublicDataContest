import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class MoneyPage extends StatelessWidget {
  const MoneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '회계 멘토링',
      ),
      body: Center(
        child: Text('회계~~~'),
      ),
    );
  }
}
