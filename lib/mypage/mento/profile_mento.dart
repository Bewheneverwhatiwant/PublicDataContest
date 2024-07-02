import 'package:flutter/material.dart';

class ProfileMentoPage extends StatelessWidget {
  const ProfileMentoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토 프로필'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            _buildMentorInfoSection(),
            const SizedBox(height: 16),
            _buildMentorBadgeSection(),
            const SizedBox(height: 16),
            _buildMentorHistorySection(),
            const SizedBox(height: 16),
            _buildReviewButton(context),
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
            Text('현재 재취업 의사 yes/no'),
            Text('멘토 활동 상태 on/off'),
          ],
        ),
      ],
    );
  }

  Widget _buildMentorInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('멘토 정보', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(child: Text('멘토링 분야 대분류/소분류, 대분류/소분류')),
            TextButton(onPressed: () {}, child: const Text('추가하기')),
          ],
        ),
        const SizedBox(height: 8),
        const Text('멘토링 인증서',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(color: Colors.grey[300], width: 100, height: 100),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 100, height: 100),
          ],
        ),
      ],
    );
  }

  Widget _buildMentorBadgeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('멘토의 명예 배지', style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildMentorHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('멘토의 멘토링 역사', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('멘토링 별점'),
            const SizedBox(width: 8),
            Row(
              children: List.generate(
                  5, (index) => const Icon(Icons.star, color: Colors.yellow)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text('현재 멘티 수'),
        const Text('누적 멘티'),
        const Text('취업에 성공한 멘티 수'),
        const Text('누적 멘토링 수익'),
      ],
    );
  }

  Widget _buildReviewButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/allmentoreview');
        },
        child: const Text('이 멘토에 대한 리뷰 보기'),
      ),
    );
  }
}
