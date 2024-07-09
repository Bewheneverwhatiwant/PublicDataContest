import 'package:flutter/material.dart';

class SearchClassPage extends StatelessWidget {
  const SearchClassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 찾기'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: '원하는 멘토링을 검색하세요.',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: Colors.grey[300],
                    child: const Center(child: Text('멘토링1')),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    color: Colors.grey[300],
                    child: const Center(child: Text('멘토링2')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
