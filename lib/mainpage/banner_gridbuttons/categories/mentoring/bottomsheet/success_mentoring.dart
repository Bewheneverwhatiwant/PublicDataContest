import 'package:flutter/material.dart';

// 채팅방 bottom sheet에서 '멘토링 성사하기' 클릭 시 보내질 네모 UI (버튼 x)

class SuccessMentoringPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '멘토링이 성사되었습니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                Text(
                  '멘토링명: 쿠버네티스 초보 과정\n'
                  '기간: 2개월\n'
                  '횟수: 일주일 최대 2번\n'
                  '시간: 1회 최대 2시간\n'
                  '장소: 강남역 10번출구 스타벅스\n'
                  '최대 멘티 수: 2/5명',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                Spacer(),
                Text(
                  '최종 가격: 50,000원',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
