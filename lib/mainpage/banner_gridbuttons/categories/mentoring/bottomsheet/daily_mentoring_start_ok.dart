import 'package:flutter/material.dart';

// 멘토가 보낸 '시작하시겠습니까?' 에 멘티가 확인 누르면 보내질 네모 UI

class DailyMentoringStartOkPage extends StatelessWidget {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '오늘의 멘토링을 시작합니다.',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '시작시간: 17시 53분\n',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
