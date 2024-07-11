import 'package:flutter/material.dart';

// '일일 멘토링 종료할까요?' 에서 멘티가 확인 버튼 누르면 나오는 네모 UI

class DailyMentoringFinishOkPage extends StatelessWidget {
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
                  '오늘의 멘토링을 종료합니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '종료 시간: '),
                      TextSpan(
                        text: '20시 40분',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: '진행 시간: '),
                      TextSpan(
                        text: '2시간 47분',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
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
