import 'package:flutter/material.dart';

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  int amount = 50000;
  late int conversationId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('conversationId')) {
      setState(() {
        conversationId = arguments['conversationId'];
      });
    }
  }

  void _sendMoney() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('결제 완료'),
        content: const Text('송금이 완료되었습니다!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 다이얼로그 닫기
              Navigator.pop(context); // SendMoneyPage 닫기
              Navigator.pushReplacementNamed(context, '/classchat',
                  arguments: {'conversationId': conversationId});
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
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
                const Text(
                  '000멘토',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '000멘토링',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                      onPressed: () {
                        setState(() {
                          if (amount > 0) amount -= 10000;
                        });
                      },
                    ),
                    Text(
                      '${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          amount += 10000;
                        });
                      },
                    ),
                  ],
                ),
                const Text('1회분 결제', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Text('멘토링 금액 50,000원', style: TextStyle(fontSize: 16)),
                const Text('항해 Pay 수수료 2,500원', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                const Text(
                  '총 결제 금액 52,500원',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                const Text('항해pay잔액: 10,000원 | 60,000원이 자동 충전되어요',
                    style: TextStyle(fontSize: 16)),
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
