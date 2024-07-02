import 'package:flutter/material.dart';

class ProfileMentiPage extends StatelessWidget {
  const ProfileMentiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘티 프로필'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildMenteeInfoSection(),
            const SizedBox(height: 16),
            _buildMenteeBadgeSection(),
            const SizedBox(height: 16),
            _buildMenteeHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey[300],
          width: 100,
          height: 100,
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('아이디'),
            Text('이름 / 성별'),
            SizedBox(height: 8),
            Text('이메일'),
            Text('전화번호'),
            Text('거주지역'),
            SizedBox(height: 8),
            Text('현재 취업 의사 yes/no'),
            Text('멘토 활동 상태 on/off'),
          ],
        ),
      ],
    );
  }

  Widget _buildMenteeInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('멘티 정보', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(child: Text('구직 분야 대분류/소분류')),
            TextButton(onPressed: () {}, child: const Text('추가하기')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('멘티로서 별점'),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                  5, (index) => const Icon(Icons.star, color: Colors.yellow)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenteeBadgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('멘티의 명예 배지', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(color: Colors.grey[300], width: 50, height: 50),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 50, height: 50),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 50, height: 50),
          ],
        ),
      ],
    );
  }

  Widget _buildMenteeHistorySection() {
    const List<Map<String, String>> menteeHistory = [
      {
        'title': '000멘토 | 000멘토링',
        'date': '2024.6.1~2024.7.1',
        'price': '50,000'
      },
      {
        'title': '000멘토 | 000멘토링',
        'date': '2024.6.1~2024.7.1',
        'price': '50,000'
      },
      {
        'title': '000멘토 | 000멘토링',
        'date': '2024.6.1~2024.7.1',
        'price': '50,000'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('멘티의 모든 멘토링 내역',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 8),
        const Text('완료된 멘토링만 표시됩니다.'),
        const SizedBox(height: 8),
        ...menteeHistory.map((history) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(history['title']!,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(history['date']!),
                  Text(history['price']!),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
