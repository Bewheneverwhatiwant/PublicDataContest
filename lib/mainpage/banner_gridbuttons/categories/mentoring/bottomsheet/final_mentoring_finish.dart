import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FinalMentoringFinishPage extends StatelessWidget {
  final String timestamp;
  final int conversationId;
  final int receiverId;
  final int? classId;
  final int? id;

  const FinalMentoringFinishPage({
    Key? key,
    required this.timestamp,
    required this.conversationId,
    required this.receiverId,
    this.classId,
    this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth / 1.5,
      height: 200,
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Image.asset(
                        'images/logo.png',
                        width: 60,
                        height: 40,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '모든 멘토링이 종료되었습니다.',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '멘토링을 통해 더욱 성장하신 것을 축하드립니다.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Hang Hae',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 25,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String? role = prefs.getString('role');

                                    if (role == 'mentee') {
                                      _showReportModal(context, receiverId);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text('멘티만 이용할 수 있는 기능입니다!'),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    '사용자 신고',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReportModal(BuildContext context, int receiverId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController reportController = TextEditingController();
        return AlertDialog(
          title: const Text('사용자 신고'),
          content: TextField(
            controller: reportController,
            maxLines: 10,
            decoration: const InputDecoration(
              hintText: '신고 사유를 작성해주세요. 구체적일 수록 좋아요. 3일 내 관리자가 확인하여 조치될 예정입니다.',
              hintStyle: TextStyle(fontSize: 12),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final reportContent = reportController.text;
                final prefs = await SharedPreferences.getInstance();
                final accessToken = prefs.getString('accessToken') ?? '';
                final apiServer = dotenv.env['API_SERVER'] ?? '';
                final url = '$apiServer/api/auth/report_user';

                final response = await http.post(
                  Uri.parse(url),
                  headers: {
                    'Authorization': 'Bearer $accessToken',
                    'Content-Type': 'application/json',
                  },
                  body: json.encode({
                    'reportContent': reportContent,
                    'reportedUserId': receiverId,
                  }),
                );

                Navigator.of(context).pop();
                if (response.statusCode != 200) {
                  print(response);
                  print('전달된 receiverId는 ${receiverId}');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: response.statusCode == 200
                        ? const Text('사용자 신고가 완료되었습니다!')
                        : const Text('신고는 한번만 가능합니다.'),
                    backgroundColor:
                        response.statusCode == 200 ? Colors.green : Colors.red,
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
