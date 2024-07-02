import 'package:flutter/material.dart';

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
                Navigator.of(context).pop();
                _showCompletionDialog(context);
              },
              child: const Text('입력 완료'),
            ),
          ],
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('완료'),
          content: const Text('입력 완료되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('항해Pay 관리', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _showInputModal(context),
          child: Row(
            children: [
              Icon(Icons.add, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  color: Colors.grey[300],
                  height: 100,
                  child: const Center(child: Text('아직 등록한 계좌가 없어요')),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
