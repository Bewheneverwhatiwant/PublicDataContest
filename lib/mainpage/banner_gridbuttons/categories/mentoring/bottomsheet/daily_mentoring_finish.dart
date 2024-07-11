import 'package:flutter/material.dart';

// 채팅방에서 bottom sheet의 일일 멘토링 종료하기 클릭 시 보내질 네모 UI

class DailyMentoringFinishPage extends StatelessWidget {
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
                  '오늘의 멘토링, 종료할까요?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '멘토링이 종료됐다면, 멘티가 아래의 ‘종료하기’ 버튼을 눌러주세요. 멘티만 누를 수 있습니다.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // 종료하기 버튼 클릭 시
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text('종료하기'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
