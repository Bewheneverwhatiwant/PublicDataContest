import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void showCustomBottomSheet(BuildContext context, int conversationId) {
  int? selectedClassId;

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
              title: const Text('일일 멘토링 시작하기'),
              onTap: () async {
                Navigator.pop(context);
                // if (selectedClassId == null) {
                //   _showAlertDialog(context, '입금 요청을 먼저 해야합니다.');
                //   return;
                // }
                _updatePaymentStatus(
                    context, conversationId, 'DAILY_MENTORING_STARTED');
                await _updateMentoring(context, selectedClassId!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('일일 멘토링 종료하기'),
              onTap: () async {
                Navigator.pop(context);
                // if (selectedClassId == null) {
                //   _showAlertDialog(context, '입금 요청을 먼저 해야합니다.');
                //   return;
                // }
                _updatePaymentStatus(
                    context, conversationId, 'DAILY_MENTORING_ENDED');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('최종 멘토링 종료 요청하기'),
              onTap: () async {
                Navigator.pop(context);
                // if (selectedClassId == null) {
                //   _showAlertDialog(context, '입금 요청을 먼저 해야합니다.');
                //   return;
                // }
                _updatePaymentStatus(
                    context, conversationId, 'FINAL_MENTORING_ENDED');
                await _finalFinishMentoring(context, selectedClassId!);
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
                _showAlertDialog(context, '오류가 발생했습니다.');
              }
            },
          ),
        ],
      );
    },
  );
}

// 여기서 상태 조절
Future<void> _updatePaymentStatus(
    BuildContext context, int conversationId, String status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  if (accessToken == null) return;

  final apiServer = dotenv.env['API_SERVER'];
  final url = Uri.parse('$apiServer/api/chat/update_payment_status');
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'conversationId': conversationId,
      'paymentStatus': status,
    }),
  );

  if (response.statusCode != 200) {
    _showAlertDialog(context, '오류가 발생했습니다.');
    print(conversationId);
    print(status);
    print('update payment status의 응답값: ${response.body}');
  }
}

Future<void> _updateMentoring(BuildContext context, int classId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  if (accessToken == null) return;

  final apiServer = dotenv.env['API_SERVER'];
  final url =
      Uri.parse('$apiServer/api/mentoring/update_mentoring?classId=$classId');
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    _showAlertDialog(context, 'update mentoring에서 오류가 발생했습니다.');

    print('update mentoring의 응답값: ${response.body}');
  } else {
    const AlertDialog(title: Text('오늘의 멘토링을 시작합니다!'));
  }
}

Future<void> _finalFinishMentoring(BuildContext context, int classId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  if (accessToken == null) return;

  final apiServer = dotenv.env['API_SERVER'];
  final url = Uri.parse(
      '$apiServer/api/mentoring/final_finish_mentoring?classId=$classId');
  final response = await http.put(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode != 200) {
    _showAlertDialog(context, '오류가 발생했습니다.');
    print('final finish 멘토링의 응답값: ${response.body}');
  } else {
    const AlertDialog(title: Text('모든 멘토링이 종료되었습니다!'));
  }
}

void _showAlertDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('알림'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
