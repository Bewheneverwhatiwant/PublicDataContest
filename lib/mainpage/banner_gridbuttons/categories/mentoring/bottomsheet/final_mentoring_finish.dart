import 'package:flutter/material.dart';

// 채팅방 bottom sheet에서 '최종 멘토링 종료' 클릭 시 보내질 네모 UI

class FinalMentoringFinishPage extends StatelessWidget {
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
                  '모든 멘토링을 종료할까요?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  '멘토링이 완전히 종료되었다면, 멘티가 아래의 \'멘토링 종료\' 버튼을 눌러주세요. 멘티만 누를 수 있습니다.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // 멘토링 종료 버튼 클릭 시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        minimumSize: Size(140, 50),
                      ),
                      child: const Text(
                        '멘토링 종료',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // 환불 신텅 버튼 클릭 시
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[300],
                        minimumSize: const Size(140, 50),
                      ),
                      child: const Text(
                        '환불 신청',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
