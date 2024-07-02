import 'package:flutter/material.dart';

class ClassChatPage extends StatelessWidget {
  const ClassChatPage({Key? key}) : super(key: key);

  Widget chat(bool isMe, String message) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('000멘토 - 000 멘토링'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '멘토와의 채팅방입니다.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                chat(false, '다음주 화요일부터 어떠세요?'),
                chat(true, '넵 3일 후 강남역 스타벅스에서 뵈어요 ~~'),
                // 서버에서 받아와서 반복 출력!
              ],
            ),
          ),
        ],
      ),
    );
  }
}
