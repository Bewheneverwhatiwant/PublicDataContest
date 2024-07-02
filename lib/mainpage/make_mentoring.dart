import 'package:flutter/material.dart';

class MakeMentoring extends StatefulWidget {
  const MakeMentoring({super.key});

  @override
  _MakeMentoringState createState() => _MakeMentoringState();
}

class _MakeMentoringState extends State<MakeMentoring> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('멘토링 개설하기'),
          content: const Text('성공적으로 개설되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 개설하기'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '분야',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: const Text(
                        'IT/웹',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('변경하기'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링 이름',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '멘토링 이름을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링 희망 지역',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '1회당 멘토링 시간',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hourController,
                      decoration: const InputDecoration(
                        labelText: '시간',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '시간을 입력하세요.';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null || intValue < 0 || intValue > 12) {
                          return '0 이상 12 이하의 숫자를 입력하세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _minuteController,
                      decoration: const InputDecoration(
                        labelText: '분',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '분을 입력하세요.';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null ||
                            intValue < 0 ||
                            intValue >= 60) {
                          return '0 이상 60 이하의 숫자를 입력하세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '1회당 멘토링 가격',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: '원',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '가격을 입력하세요.';
                        }
                        final intValue = int.tryParse(value);
                        if (intValue == null ||
                            intValue < 0 ||
                            intValue > 1000000) {
                          return '0 이상 1000000 이하의 숫자를 입력하세요.';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('가격 책정 가이드라인 보기'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링 설명',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '멘토링 설명을 입력하세요.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '* 멘토링 기간, 횟수는 멘티와 차후 협의하여 결정',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: _submitForm,
                    child: const Text('멘토링 개설하기'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
