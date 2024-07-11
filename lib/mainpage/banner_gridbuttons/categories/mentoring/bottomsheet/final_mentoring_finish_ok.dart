import 'package:flutter/material.dart';

// '최종 멘토링 종료할까요?' 에서 멘티가 확인 버튼 클릭 시 보내질 네모 UI

class FinalMentoringFinishOkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 600,
          height: 600,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '모든 멘토링이 종료되었습니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(height: 8),
                const Text(
                  '멘토링명: 쿠버네티스 초보 과정\n'
                  '기간: 2개월\n'
                  '횟수: 일주일 최대 2번\n'
                  '시간: 1회 최대 2시간\n'
                  '장소: 강남역 10번출구 스타벅스\n'
                  '최대 멘티 수: 2/5명',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '최종 가격: 50,000원',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '최종 멘토링 횟수: 8회',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // 멘토링 리뷰 작성하기 버튼 클릭 시
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '멘토링 리뷰 작성하기',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 멘토 신고 버튼 클릭 시
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[300],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '멘토 신고',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // 취업했어요 버튼 클릭 시
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[400],
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    '취업했어요',
                    style: TextStyle(fontSize: 18, color: Colors.black),
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
