import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            _buildMentoringInfo(context),
            const SizedBox(height: 16),
            _buildLikeAndChat(context),
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

  Widget _buildMentoringInfo(BuildContext context) {
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
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/profilemento');
                },
                icon: const Icon(Icons.person, color: Colors.yellow),
                label: const Text('강대명 멘토'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 4),
              const Text('4.5/5'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/reviewlist');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  '리뷰(32)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
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

  Widget _buildLikeAndChat(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.blue),
              onPressed: () async {
                bool isLoggedIn = await _checkIfLoggedIn();
                if (isLoggedIn) {
                  // 좋아요 버튼 클릭 시 동작 추가
                } else {
                  _showLoginAlert(context);
                }
              },
            ),
            const Text('좋아요 2개'),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () async {
            bool isLoggedIn = await _checkIfLoggedIn();
            if (isLoggedIn) {
              Navigator.pushNamed(context, '/classchat');
            } else {
              _showLoginAlert(context);
            }
          },
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text('멘토와의 채팅'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<bool> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    return accessToken != null;
  }

  void _showLoginAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('로그인 후 이용하실 수 있는 기능입니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
