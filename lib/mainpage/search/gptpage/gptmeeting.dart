import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GPTMeetingPage extends StatefulWidget {
  @override
  _GPTMeetingPageState createState() => _GPTMeetingPageState();
}

class _GPTMeetingPageState extends State<GPTMeetingPage> {
  int currentQuestionIndex = 0;
  final int totalQuestions = 10;
  final TextEditingController _answerController = TextEditingController();
  final FlutterTts flutterTts = FlutterTts(); // TTS 객체 생성

  late List<String> questions;
  late String ask;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null) {
      ask = args;
      questions = _splitQuestions(ask);
    } else {
      questions =
          List.generate(totalQuestions, (index) => '기본 질문 텍스트 ${index + 1}');
    }
  }

  List<String> _splitQuestions(String ask) {
    // 1번, 2번... 형식으로 되어 있는 질문을 나눔
    return ask
        .split(RegExp(r'\d+\.\s'))
        .where((q) => q.trim().isNotEmpty)
        .toList();
  }

  Future<void> _saveAnswer(String question, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(question, answer);
  }

  Future<void> _getFeedback() async {
    // 질문-답변 쌍을 GPT에게 전송하고 피드백을 요청하는 로직
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> questionAnswerPairs = {};
    for (String question in questions) {
      questionAnswerPairs[question] = prefs.getString(question) ?? '';
    }

    final String message = questionAnswerPairs.entries
        .map((entry) => '질문: ${entry.key}\n답변: ${entry.value}')
        .join('\n\n');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('면접 피드백을 생성 중입니다...'),
          ],
        ),
      ),
    );

    try {
      String apiKey = dotenv.env['GPT_KEY'] ?? '';
      if (apiKey.isEmpty) {
        throw Exception('GPT_KEY is missing in .env file');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

      var requestBody = jsonEncode({
        'model': 'gpt-4-turbo',
        'messages': [
          {
            'role': 'user',
            'content': '각 질문에 대해 사용자가 답변한 내용을 검토하고, 피드백하라.\n\n$message'
          }
        ]
      });

      var response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        var feedback = decodedResponse['choices'][0]['message']['content'];

        Navigator.pop(context);

        print(feedback);

        Navigator.pushNamed(
          context,
          '/feedback',
          arguments: feedback,
        );
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Failed to get response')),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("ko-KR"); // 한국어 설정
    await flutterTts.setSpeechRate(0.5); // 속도 설정
    await flutterTts.speak(text); // TTS 시작
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '생성형AI면접관과 면접 중입니다.',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: (currentQuestionIndex + 1) / totalQuestions,
                      backgroundColor: Colors.blue[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${currentQuestionIndex + 1} / $totalQuestions'),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    '면접관의 질문',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.volume_up),
                    onPressed: () {
                      _speak(questions[currentQuestionIndex]); // 여기서 TTS
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  questions[currentQuestionIndex],
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/meetingImg.png',
                fit: BoxFit.cover,
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                '나의 답변',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _answerController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  String currentQuestion = questions[currentQuestionIndex];
                  String currentAnswer = _answerController.text;

                  await _saveAnswer(currentQuestion, currentAnswer);

                  if (currentQuestionIndex < totalQuestions - 1) {
                    setState(() {
                      currentQuestionIndex++;
                      _answerController.clear();
                    });
                  } else {
                    await _getFeedback();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  currentQuestionIndex < totalQuestions - 1
                      ? '다음 질문으로'
                      : '피드백 받기',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/gptpage');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '면접 종료하기',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
