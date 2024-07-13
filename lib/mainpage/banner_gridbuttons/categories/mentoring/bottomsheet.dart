import 'package:flutter/material.dart';

void showCustomBottomSheet(
    BuildContext context, int conversationId, int classId) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.grey[300],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.attach_money),
              title: const Text('입금 요청하기'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/sendmoney',
                    arguments: {'conversationId': conversationId});
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('일일 멘토링 시작 요청하기'),
              onTap: () {
                Navigator.pop(context);
                // update_mentoring API 연동하고, 200이면 daily_mentoring_start 컴포넌트 띄우기
              },
            ),
            ListTile(
              leading: const Icon(Icons.stop),
              title: const Text('일일 멘토링 종료 요청하기'),
              onTap: () {
                Navigator.pop(context);
                // API 없이 daily_mentoring_finish 컴포넌트만 띄우기
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('최종 멘토링 종료 요청하기'),
              onTap: () {
                Navigator.pop(context);
                // final_finish_mentoring API 요청하기
              },
            ),
          ],
        ),
      );
    },
  );
}
