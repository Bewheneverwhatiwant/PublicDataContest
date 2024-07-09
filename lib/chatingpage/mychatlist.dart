import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyChatList extends StatefulWidget {
  const MyChatList({super.key});

  @override
  _MyChatListState createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
  bool _isLoggedIn = false;
  List<dynamic> chatList = [];
  bool _isLoading = true;
  bool _hasError = false;
  String? _role;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken');
    final role = prefs.getString('role');
    setState(() {
      _isLoggedIn = accessToken != null;
      _role = role;
    });
    if (_isLoggedIn) {
      _fetchChatList(accessToken!);
    }
  }

  Future<void> _fetchChatList(String token) async {
    final apiServer = dotenv.env['API_SERVER'];
    final url = Uri.parse('$apiServer/api/chat/chat_list');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          chatList = data;
          _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomNewAppBar(title: '내 채팅'),
      body: _isLoggedIn ? _buildChatList() : _buildLoginPrompt(),
    );
  }

  Widget _buildChatList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (chatList.isEmpty && !_hasError) {
      return const Center(
        child: Text(
          '아직 채팅방이 없어요. 멘토와 채팅을 시작해보세요.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    } else if (_hasError) {
      return const Center(
        child: Text(
          '오류가 발생했습니다.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: chatList.length,
        itemBuilder: (context, index) {
          final chat = chatList[index];
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/classchat',
                arguments: {'conversationId': chat['conversationId']},
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '대화상대: ${_role == 'mentee' ? chat['mentorName'] : chat['menteeName']}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '생성일: ${chat['startDate']}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  Widget _buildLoginPrompt() {
    return const Center(
      child: Text(
        '로그인 후 이용하실 수 있는 기능입니다.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
