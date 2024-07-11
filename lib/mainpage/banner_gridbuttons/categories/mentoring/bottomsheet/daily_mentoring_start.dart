import 'package:flutter/material.dart';

// 채팅방 bottom sheet에서 일일 멘토링 시작하기 클릭 시 보내질 네모 UI

class DailyMentoringStartPage extends StatelessWidget {
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '오늘의 멘토링, 준비됐나요?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '멘토링을 시작했다면, 멘티가 아래의 ‘시작하기’ 버튼을 눌러주세요. 멘티만 누를 수 있습니다.\n'
                  '시작하기 전까지 환불이 가능합니다.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 시작하기 버튼 클릭 시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(120, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('시작하기'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // 환불 버튼 클릭 시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[100],
                        foregroundColor: Colors.black,
                        minimumSize: const Size(120, 50),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('환불 신청'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
