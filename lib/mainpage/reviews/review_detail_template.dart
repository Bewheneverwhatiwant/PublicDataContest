import 'package:flutter/material.dart';

// 특정 리뷰 클릭 시 상세화면 템플릿

class HomeReviewDetailPage extends StatelessWidget {
  const HomeReviewDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('멘토링 리뷰'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '멘토링 정보',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildMentoringInfo(),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                '멘티 리뷰',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            _buildMenteeReview(),
          ],
        ),
      ),
    );
  }

  Widget _buildMentoringInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '멘토링명 : 어쩌구',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            '멘토 : 어쩌구',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('기간 : 2개월'),
          Text('가격 : 50,000원'),
        ],
      ),
    );
  }

  Widget _buildMenteeReview() {
    final int stars = 5; // 별점 예시 데이터

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              '평점',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Row(
              children: List.generate(stars, (index) {
                return const Icon(
                  Icons.star,
                  color: Colors.yellow,
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'abcdef',
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
