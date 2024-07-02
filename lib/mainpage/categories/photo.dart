import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNewAppBar(
        title: '사진 멘토링',
      ),
      body: Center(
        child: Text('사진사진'),
      ),
    );
  }
}
