import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class DesignPage extends StatelessWidget {
  const DesignPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '디자인 멘토링',
      ),
      body: Center(
        child: Text('디자인~~~'),
      ),
    );
  }
}
