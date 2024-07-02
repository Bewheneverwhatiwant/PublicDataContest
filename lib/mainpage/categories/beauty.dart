import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class BeautyPage extends StatelessWidget {
  const BeautyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '미용 멘토링',
      ),
      body: Center(
        child: Text('미용미용~~~'),
      ),
    );
  }
}
