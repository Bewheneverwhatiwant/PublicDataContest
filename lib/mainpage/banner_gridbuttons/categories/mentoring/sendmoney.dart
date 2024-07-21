import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  late int conversationId;
  late int classId;
  String titlename = '';
  String mentorName = '';
  String mentoringName = '';
  int mentoringPrice = 0;
  int amount = 0;
  double fee = 0.0;
  int totalAmount = 0;
  int autoRechargeAmount = 0;
  int count = 1;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      conversationId = arguments['conversationId'];
      classId = arguments['classId'];
      // 임시방편 처리. 나중에 /chatting detail에 결제요청 status 바로 반영되도록 수정되면 다시 확인할 것 !
      //classId = 5;
      titlename = arguments['titlename'];
    } else {
      // 기본값 설정
      conversationId = 0;
      classId = 0;
      titlename = 'Unknown';
    }
    _fetchMentoringDetails();
  }

  Future<void> _fetchMentoringDetails() async {
    final apiServer = dotenv.env['API_SERVER'];
    final detailUrl =
        Uri.parse('$apiServer/api/mentoring/mentoring_detail?classId=$classId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) return;

    final detailResponse = await http.get(
      detailUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (detailResponse.statusCode == 200) {
      final data = json.decode(detailResponse.body);
      setState(() {
        mentorName = data['mentorName'];
        mentoringName = data['name'];
        mentoringPrice = data['price'];
        amount = mentoringPrice;
        fee = double.parse((amount * 0.05).toStringAsFixed(1));
        totalAmount = amount + fee.toInt();
        autoRechargeAmount = ((totalAmount / 10000).ceil() * 10000).toInt();
        if (totalAmount < 10000) {
          autoRechargeAmount = 10000;
        }
      });
    } else {
      // 오류 처리
      print('mentoring_detail API 요청 실패');
    }
  }

  Future<void> _sendMoney() async {
    final apiServer = dotenv.env['API_SERVER'];
    final updatePaymentStatusUrl =
        Uri.parse('$apiServer/api/chat/update_payment_status');
    final postPaymentHistoryUrl =
        Uri.parse('$apiServer/api/payment_history/post_payment_history');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    if (accessToken == null) return;

    final response1 = await http.put(
      updatePaymentStatusUrl,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'conversationId': conversationId,
        'paymentStatus': 'PAYMENT_COMPLETED',
      }),
    );

    if (response1.statusCode == 200) {
      final response2 = await http.post(
        postPaymentHistoryUrl,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'classId': classId,
          'count': count,
        }),
      );

      if (response2.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('결제 완료'),
            content: const Text('송금이 완료되었습니다!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/classchat',
                      arguments: {
                        'conversationId': conversationId,
                        'classId': classId,
                        'titlename': titlename,
                      });
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to post payment history');
        print('classId: $classId');
        print('count: $count');
      }
    } else {
      // Handle error
    }
  }

  void _increaseAmount() {
    setState(() {
      amount += mentoringPrice;
      count += 1;
      fee = double.parse((amount * 0.05).toStringAsFixed(1));
      totalAmount = amount + fee.toInt();
      autoRechargeAmount = ((totalAmount / 10000).ceil() * 10000).toInt();
      if (totalAmount < 10000) {
        autoRechargeAmount = 10000;
      }
    });
  }

  void _decreaseAmount() {
    if (amount > mentoringPrice) {
      setState(() {
        amount -= mentoringPrice;
        count -= 1;
        fee = double.parse((amount * 0.05).toStringAsFixed(1));
        totalAmount = amount + fee.toInt();
        autoRechargeAmount = ((totalAmount / 10000).ceil() * 10000).toInt();
        if (totalAmount < 10000) {
          autoRechargeAmount = 10000;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('송금'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  '$mentorName 멘토',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$mentoringName 멘토링',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  '항해 Pay 수수료 5%',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decreaseAmount,
                    ),
                    Text(
                      '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _increaseAmount,
                    ),
                  ],
                ),
                Text('$count회분 한번에 결제', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Text(
                    '멘토링 금액 ${mentoringPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                    style: const TextStyle(fontSize: 16)),
                Text(
                    '항해 Pay 수수료 ${fee.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                    style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text(
                  '총 결제 금액 ${totalAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  '항해pay잔액: 10,000원 | ${autoRechargeAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원이 자동 충전되어요',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F79F7),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: _sendMoney,
                  child: const Text('보내기',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
