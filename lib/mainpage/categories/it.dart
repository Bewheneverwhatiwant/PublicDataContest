import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class ITPage extends StatelessWidget {
  const ITPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: 'IT 멘토링',
      ),
      body: Center(
        child: Text('ITIT~~~'),
      ),
    );
  }
}
