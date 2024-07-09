import 'package:flutter/material.dart';

class MentoMyClassPage extends StatefulWidget {
  const MentoMyClassPage({Key? key}) : super(key: key);

  @override
  _MentoMyClassPageState createState() => _MentoMyClassPageState();
}

class _MentoMyClassPageState extends State<MentoMyClassPage> {
  String _status = '진행 중';

  void _handleRadioValueChange(String? value) {
    setState(() {
      _status = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('나의 모든 멘토링 관리'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // 삭제 버튼 클릭 시 동작 추가
              _showDeleteDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMentoringInfo(),
            const SizedBox(height: 16),
            _buildLikeAndComment(),
            const SizedBox(height: 16),
            _buildStatusSection(),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('삭제 확인'),
          content: const Text('정말로 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                // 삭제 로직 추가
                Navigator.of(context).pop();
              },
              child: const Text('삭제'),
            ),
          ],
        );
      },
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
          Row(
            children: const [
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
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

  Widget _buildLikeAndComment() {
    return Row(
      children: [
        Icon(Icons.thumb_up_alt_outlined, color: Colors.blue),
        const SizedBox(width: 4),
        const Text('멘토링 좋아요 2개'),
        const SizedBox(width: 16),
        Icon(Icons.comment, color: Colors.blue),
        const SizedBox(width: 4),
        const Text('댓글(2)'),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('현재 진행 여부',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: [
                  Radio<String>(
                    value: '진행 중',
                    groupValue: _status,
                    onChanged: _handleRadioValueChange,
                  ),
                  const Text('진행 중'),
                  Radio<String>(
                    value: '진행 종료',
                    groupValue: _status,
                    onChanged: _handleRadioValueChange,
                  ),
                  const Text('진행 종료'),
                ],
              ),
            ],
          ),
          const Divider(),
          const Text('모집 상태', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(
                _status == '진행 중' ? '모집 중' : '모집 마감',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _status == '진행 중' ? Colors.green : Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '멘토링이 현재 진행 중이 아닌 경우, 자동으로 모집상태가 닫힙니다.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
