import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void showCustomBottomSheet(BuildContext context, int conversationId) {
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
                showMentoringSelectionDialog(context, conversationId);
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

void showMentoringSelectionDialog(BuildContext context, int conversationId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String selectedMentoring = '멘토링1';
      int classId = 7; // 초기값은 멘토링1의 classId

      return AlertDialog(
        title: const Text(
          '이 멘티가 결제해야 하는 멘토링을\n골라주세요.',
          style: TextStyle(fontSize: 16),
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                  title: const Text('멘토링1'),
                  value: '멘토링1',
                  groupValue: selectedMentoring,
                  onChanged: (value) {
                    setState(() {
                      selectedMentoring = value.toString();
                      classId = 7;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('멘토링2'),
                  value: '멘토링2',
                  groupValue: selectedMentoring,
                  onChanged: (value) {
                    setState(() {
                      selectedMentoring = value.toString();
                      classId = 8;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text('멘토링3'),
                  value: '멘토링3',
                  groupValue: selectedMentoring,
                  onChanged: (value) {
                    setState(() {
                      selectedMentoring = value.toString();
                      classId = 9;
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              final accessToken = prefs.getString('accessToken');
              if (accessToken == null) return;

              final apiServer = dotenv.env['API_SERVER'];
              final url =
                  Uri.parse('$apiServer/api/chat/update_payment_status');
              final response = await http.put(
                url,
                headers: {
                  'Authorization': 'Bearer $accessToken',
                  'Content-Type': 'application/json',
                },
                body: json.encode({
                  'conversationId': conversationId,
                  'paymentStatus': 'PAYMENT_REQUESTED',
                }),
              );

              if (response.statusCode == 200) {
                Navigator.pop(context);
              } else {
                const AlertDialog(title: Text('오류가 발생했습니다.'));
              }
            },
          ),
        ],
      );
    },
  );
}
