import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ClassChatPage extends StatefulWidget {
  const ClassChatPage({Key? key}) : super(key: key);

  @override
  _ClassChatPageState createState() => _ClassChatPageState();
}

class _ClassChatPageState extends State<ClassChatPage> {
  List<dynamic> messages = [];
  bool _isLoading = true;
  bool _hasError = false;
  String? _role;
  int? _conversationId;
  String? _senderType;
  String? _senderName;
  final TextEditingController _controller = TextEditingController();
  bool _showBottomButtons = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null && arguments.containsKey('conversationId')) {
        _conversationId = arguments['conversationId'];
        _saveConversationId(_conversationId!);
      }
      _loadConversationIdAndFetchMessages();
    });
  }

  Future<void> _saveConversationId(int conversationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('conversationId', conversationId);
  }

  Future<void> _loadConversationIdAndFetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _conversationId ??= prefs.getInt('conversationId');
    _role = prefs.getString('role');
    final accessToken = prefs.getString('accessToken');
    if (_conversationId != null && accessToken != null) {
      _fetchMessages(_conversationId!, accessToken);
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _fetchMessages(int conversationId, String token) async {
    final apiServer = dotenv.env['API_SERVER'];
    final url = Uri.parse(
        '$apiServer/api/chat/chatting_detail?conversationId=$conversationId');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          messages = data;
          if (messages.isNotEmpty) {
            _senderType = messages[0]['senderType'].toString();
            _senderName = messages[0]['senderName'].toString();
          }
          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      print('Error: $e');
    }
  }

  Future<void> _sendMessage(String content) async {
    final apiServer = dotenv.env['API_SERVER'];
    final url = Uri.parse('$apiServer/api/chat/chatting');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null || _conversationId == null) return;

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'conversationId': _conversationId,
          'content': content,
        }),
      );
      if (response.statusCode == 200) {
        print('Sent: conversationId=$_conversationId, content=$content');
        _controller.clear();
        _fetchMessages(_conversationId!, token);
      } else {
        print(
            'Failed to send: conversationId=$_conversationId, content=$content');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showBottomSheet(BuildContext context) {
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
                  Navigator.pushNamed(context, '/sendmoney',
                      arguments: {'conversationId': _conversationId});
                },
              ),
              ListTile(
                leading: const Icon(Icons.check),
                title: const Text('멘토링 성사하기'),
                onTap: () {
                  Navigator.pop(context);
                  // handle action
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('최종 멘토링 종료 요청하기'),
                onTap: () {
                  Navigator.pop(context);
                  // handle action
                },
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('일일 멘토링 시작 요청하기'),
                onTap: () {
                  Navigator.pop(context);
                  // handle action
                },
              ),
              ListTile(
                leading: const Icon(Icons.stop),
                title: const Text('일일 멘토링 종료 요청하기'),
                onTap: () {
                  Navigator.pop(context);
                  // handle action
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget chat(bool isMe, String message) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(_senderName != null && _senderType != null
            ? '$_senderName $_senderType와의 채팅'
            : '멘토와의 채팅방입니다.'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '미풍양속을 해치치 않는 채팅을 해주세요.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _hasError
                    ? const Center(child: Text('오류가 발생했습니다.'))
                    : messages.isEmpty
                        ? const Center(
                            child: Text(
                              '채팅을 시작해보세요.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe = (_role == message['senderType']);
                              return chat(isMe, message['content']);
                            },
                          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.add, color: Color(0xFF6F79F7)),
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '메시지를 입력하세요...',
                    ),
                    onTap: () {
                      setState(() {
                        _showBottomButtons = false;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final content = _controller.text;
                    if (content.isNotEmpty) {
                      _sendMessage(content);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
