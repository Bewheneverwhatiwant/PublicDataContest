import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyPaySection extends StatefulWidget {
  const MyPaySection({Key? key}) : super(key: key);

  @override
  _MyPaySectionState createState() => _MyPaySectionState();
}

class _MyPaySectionState extends State<MyPaySection> {
  final TextEditingController _controller = TextEditingController();

  void _showInputModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('계좌번호 입력'),
          content: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '계좌번호',
              hintText: '000-0000-0000',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('취소'),
            ),
            TextButton(
              onPressed: () {
                final String payment = _controller.text;
                Navigator.of(context).pop();
                _registerAccount(payment);
              },
              child: const Text('입력 완료'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _registerAccount(String payment) async {
    final String apiServer = dotenv.env['API_SERVER'] ?? '';
    final String? accessToken = await _getAccessToken();

    if (accessToken == null) {
      print('AccessToken not found');
      return;
    }

    final response = await http.put(
      Uri.parse('$apiServer/api/auth/register_pay?payment=$payment'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('계좌가 등록되었습니다: $payment')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('계좌 등록에 실패했습니다: $payment')),
      );
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '항해Pay 관리',
            style: TextStyle(
              color: GlobalColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showInputModal(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.add, color: GlobalColors.mainColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '계좌번호를 등록해주세요',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '등록된 계좌번호가 없습니다.',
                          style: TextStyle(
                            fontSize: 14,
                            color: GlobalColors.lightgray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
