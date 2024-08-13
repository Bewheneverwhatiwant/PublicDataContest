import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './GradientIconButton.dart';

class WarmaiPage extends StatefulWidget {
  @override
  _WarmaiPageState createState() => _WarmaiPageState();
}

class _WarmaiPageState extends State<WarmaiPage> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  Future<void> sendMessage(String message) async {
    setState(() {
      messages.add({"role": "user", "content": message});
      messages.add({"role": "assistant", "content": "A!가 답변을 작성하고 있어요..."});
    });

    try {
      // 환경 변수 불러오기
      String apiKey = dotenv.env['GPT_KEY'] ?? '';

      if (apiKey.isEmpty) {
        throw Exception('Missing GPT_KEY');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      var requestBody = jsonEncode({
        'model': 'gpt-4-turbo',
        'messages': [
          {'role': 'user', 'content': message}
        ]
      });

      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseBody =
            utf8.decode(response.bodyBytes); // 인코딩 문제 해결을 위해 utf8로 디코딩
        var decodedResponse = json.decode(responseBody);
        var assistantMessage =
            decodedResponse['choices'][0]['message']['content'];

        setState(() {
          messages[messages.length - 1]['content'] = assistantMessage;
        });
        //print("GPT 응답: $assistantMessage");
      } else {
        setState(() {
          messages[messages.length - 1]['content'] =
              "Error: Failed to get response";
        });
        print("Error: Failed to get response");
      }
    } catch (e) {
      setState(() {
        messages[messages.length - 1]['content'] = "Error: $e";
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'AI와의 채팅방',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20),
                Column(
                  children: [
                    const Text(
                      '안녕하세요, 저는 당신을 위한\n항해의 생성형 AI예요!',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFECECEC),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20),
                              Text(
                                '저는 이런 일을 할 수 있어요.',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '• 오랜 구직 활동으로 지치고 우울하시다면, 알려주세요. 활기를 되찾으실 수 있도록 취미를 추천해드려요!',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 10),
                              Text(
                                '• 희망하시는 직군을 위해 어떤 자격증을 취득해야 하는지 모르시겠다면, 질문해주세요!',
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(height: 20),
                              Text(
                                '어떤 것을 도와드릴까요?',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ...messages.map((msg) => buildMessage(msg)).toList(),
                SizedBox(height: 80),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF33CBAC),
                            Color(0xFF1089E4),
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      padding: EdgeInsets.all(1.5), // Border width
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.0),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'AI에게 무엇이든 물어보세요....',
                        ),
                      ),
                    ),
                  ),
                  GradientIconButton(
                    icon: Icons.send,
                    onPressed: () {
                      String userMessage = _controller.text.trim();
                      if (userMessage.isNotEmpty) {
                        sendMessage(userMessage);
                        _controller.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Map<String, String> msg) {
    bool isUser = msg['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: msg['content'] == 'AI가 답변을 작성하고 있어요...'
            ? _AnimatedLoadingIcon()
            : Text(msg['content'] ?? ''),
      ),
    );
  }
}

class _AnimatedLoadingIcon extends StatefulWidget {
  @override
  __AnimatedLoadingIconState createState() => __AnimatedLoadingIconState();
}

class __AnimatedLoadingIconState extends State<_AnimatedLoadingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RotationTransition(
          turns: _controller,
          child: Image.asset(
            'assets/images/icon_loading.png',
            width: 30,
            height: 30,
          ),
        ),
        SizedBox(height: 8),
        Text('AI가 답변을 작성하고 있어요...'),
      ],
    );
  }
}
