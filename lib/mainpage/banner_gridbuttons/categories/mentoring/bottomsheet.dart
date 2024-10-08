import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void showCustomBottomSheet(
  BuildContext context,
  int conversationId,
) {
  int? selectedClassId;
  int? paymentRequestedId;

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
                _updatePaymentStatus(
                    context, conversationId, 'DAILY_MENTORING_ENDED');
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('최종 멘토링 종료 요청하기'),
              onTap: () async {
                Navigator.pop(context);
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
      return FutureBuilder(
        future: _fetchMentorMentoringData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return AlertDialog(
              title: const Text('오류'),
              content: const Text('데이터를 불러오는 중 오류가 발생했습니다.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('확인'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          } else {
            final mentoringData = snapshot.data as List<dynamic>;
            String selectedMentoring =
                mentoringData.isNotEmpty ? mentoringData[0]['name'] : '';
            int classId =
                mentoringData.isNotEmpty ? mentoringData[0]['classId'] : 0;

            return AlertDialog(
              title: const Text(
                '이 멘티가 결제해야 하는 멘토링을\n골라주세요.',
                style: TextStyle(fontSize: 16),
              ),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: mentoringData.map<Widget>((mentoring) {
                      return RadioListTile(
                        title: Text(mentoring['name']),
                        value: mentoring['name'],
                        groupValue: selectedMentoring,
                        onChanged: (value) {
                          setState(() {
                            selectedMentoring = value.toString();
                            classId = mentoring['classId'];
                            print('Selected classId: $classId');
                          });
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('확인'),
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    final accessToken = prefs.getString('accessToken');
                    if (accessToken == null) return;

                    final apiServer = dotenv.env['API_SERVER'];
                    final updateUrl = Uri.parse(
                        '$apiServer/api/chat/update_payment_status'); // /update_payment_status 먼저 호출
                    final updateResponse = await http.put(
                      updateUrl,
                      headers: {
                        'Authorization': 'Bearer $accessToken',
                        'Content-Type': 'application/json',
                      },
                      body: json.encode({
                        'conversationId': conversationId,
                        'paymentStatus': 'PAYMENT_REQUESTED',
                      }),
                    );

                    if (updateResponse.statusCode == 200) {
                      print(
                          'update_payment_status 성공: conversationId: $conversationId');
                      final detailUrl = Uri.parse(
                          '$apiServer/api/chat/chatting_detail?conversationId=$conversationId');
                      final detailResponse = await http.get(
                        detailUrl,
                        headers: {
                          'Authorization': 'Bearer $accessToken',
                        },
                      );

                      if (detailResponse.statusCode == 200) {
                        final data = json.decode(detailResponse.body);
                        final paymentStatuses =
                            data['paymentStatus'] as List<dynamic>;
                        final paymentRequestedStatus =
                            paymentStatuses.firstWhere(
                          (status) =>
                              status['paymentStatus'] == 'PAYMENT_REQUESTED',
                          orElse: () => null,
                        );

                        if (paymentRequestedStatus != null) {
                          final paymentRequestedId =
                              paymentRequestedStatus['id'];
                          print(
                              'chatting_detail 성공: paymentRequestedId: $paymentRequestedId');

                          final updateReceivedClassIdUrl = Uri.parse(
                              '$apiServer/api/chat/update_received_class_id?paymentStatus_id=$paymentRequestedId&class_id=$classId');
                          final updateReceivedClassIdResponse = await http.put(
                            updateReceivedClassIdUrl,
                            headers: {
                              'Authorization': 'Bearer $accessToken',
                              'Content-Type': 'application/json',
                            },
                          );

                          if (updateReceivedClassIdResponse.statusCode == 200) {
                            print(
                                'update_received_class_id 성공: paymentStatus_id: $paymentRequestedId, class_id: $classId');
                            Navigator.pop(context); // 모달 닫음
                            // Navigator.pushNamed(
                            //   context,
                            //   '/sendmoney',
                            //   arguments: {
                            //     'conversationId': conversationId,
                            //     'classId': classId,
                            //     'titlename': '',
                            //     'paymentRequestedId': paymentRequestedId,
                            //   },
                            // );
                          } else {
                            print(
                                'update_received_class_id 실패: paymentStatus_id: $paymentRequestedId, class_id: $classId');
                            print(
                                '응답 본문: ${updateReceivedClassIdResponse.body}');
                          }
                        } else {
                          print(
                              'chatting_detail 실패: PAYMENT_REQUESTED 상태를 찾을 수 없음');
                        }
                      } else {
                        print(
                            'chatting_detail 실패: conversationId: $conversationId');
                      }
                    } else {
                      print(
                          'update_payment_status 실패: conversationId: $conversationId');
                    }
                  },
                ),
              ],
            );
          }
        },
      );
    },
  );
}

Future<List<dynamic>> _fetchMentorMentoringData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  if (accessToken == null) return [];

  final apiServer = dotenv.env['API_SERVER'];
  final url = Uri.parse('$apiServer/api/mentoring/get_mentor_mentoring');
  final response = await http.get(
    url,
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load mentoring data');
  }
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
