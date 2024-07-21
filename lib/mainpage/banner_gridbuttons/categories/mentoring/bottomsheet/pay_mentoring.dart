import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayMentoringPage extends StatelessWidget {
  final String timestamp;
  final int conversationId;
  final int classId;
  final String titlename;
  final int paymentRequestedId;

  const PayMentoringPage({
    Key? key,
    required this.timestamp,
    required this.conversationId,
    required this.classId,
    required this.titlename,
    required this.paymentRequestedId,
  }) : super(key: key);

// 여기서는 /update_received_class_id 호출이 아니라, 넘겨받은 classId로 /mentoring_detail API 호출하는 것만 일어나야 한다.

  Future<void> _handleButtonPress(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('role');

    if (role == 'mentor') {
      // 멘토인 경우 알림 띄우기
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: const Text('멘티만 이용 가능한 기능입니다.'),
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
    } else if (role == 'mentee') {
      // 멘티인 경우 /sendmoney로 이동
      Navigator.pushNamed(
        context,
        '/sendmoney',
        arguments: {
          'conversationId': conversationId,
          'classId': classId,
          'titlename': titlename,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleButtonPress(context),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: 200,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
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
              '만나서 반가워요, 나의 멘티!',
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
                      '멘토링 비용을 결제해주세요.',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
