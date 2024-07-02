import 'package:flutter/material.dart';

class MentoringDetailPage extends StatelessWidget {
  const MentoringDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 상세 설명'),
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
            _buildCategorySection(),
            const SizedBox(height: 16),
            _buildMentoringInfo(),
            const SizedBox(height: 16),
            _buildLikeAndChat(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'IT/웹, 앱 서비스',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '진행 중/모집 마감',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildMentoringInfo() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '쿠버네티스 초급 과정 멘토링 모집합니다.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.person, color: Colors.yellow),
              SizedBox(width: 4),
              Text('강대명 멘토'),
              SizedBox(width: 8),
              Icon(Icons.star, color: Colors.yellow),
              SizedBox(width: 4),
              Text('4.5/5'),
              SizedBox(width: 8),
              Text('리뷰(32)'),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            '인프라 관리를 배우고 싶은 청년들을 위해 멘토링을 열게 되었습니다. '
            '레벨이 기술을 이해하고 있는 분들께 추천드립니다. 프로필에서 보실 수 있듯이, '
            '인터파크에서 15년간 서버 총괄을 맡았습니다. 기술협업, 입문면접에 대한 조언도 드릴 수 있으니 많은 신청 부탁드립니다.',
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('멘토링 이름: 쿠버네티스 초급 과정'),
                Text('멘토링 희망 지역: 강남역 10번 출구 스타벅스, 협의 가능'),
                Text('멘토링 기간: 2달'),
                Text('멘토링 횟수: 일주일 최대 2회'),
                Text('멘토링 시간: 1회당 최대 2시간'),
                Text('멘토링 가격: 50,000원'),
                Text('최대 멘티 수: 5명'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeAndChat() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            Icon(Icons.thumb_up_alt_outlined, color: Colors.blue),
            SizedBox(width: 4),
            Text('멘토링 좋아요 2개'),
          ],
        ),
        Row(
          children: [
            Icon(Icons.chat_bubble_outline, color: Colors.blue),
            SizedBox(width: 4),
            Text('멘토와의 채팅'),
          ],
        ),
      ],
    );
  }
}
