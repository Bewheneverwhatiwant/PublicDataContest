import 'package:flutter/material.dart';

class MentoMyClassPage extends StatelessWidget {
  const MentoMyClassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나의 모든 멘토링 관리'),
      ),
      body: Center(
        child: Container(
          color: Colors.grey[300],
          width: 300,
          height: 100,
          child: const Center(
            child: Text(
              '나의 모든 멘토링 관리',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
