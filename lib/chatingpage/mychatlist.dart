import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyChatList extends StatefulWidget {
  const MyChatList({super.key});

  @override
  _MyChatListState createState() => _MyChatListState();
}

class _MyChatListState extends State<MyChatList> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getString('accessToken') != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomNewAppBar(title: '내 채팅'),
      body: _isLoggedIn ? _buildChatList() : _buildLoginPrompt(),
    );
  }

  Widget _buildChatList() {
    const List<Map<String, String>> chatList = [
      {
        'name': '000 멘티',
        'message': '안녕하세요, 쿠버네티스 과정 멘토링 희망합니다!',
        'route': '/chat1'
      },
      {
        'name': '000 멘티',
        'message': '안녕하세요, 쿠버네티스 과정 멘토링 희망합니다!',
        'route': '/chat2'
      },
      {
        'name': '000 멘티',
        'message': '안녕하세요, 쿠버네티스 과정 멘토링 희망합니다!',
        'route': '/chat3'
      },
      {
        'name': '000 멘티',
        'message': '안녕하세요, 쿠버네티스 과정 멘토링 희망합니다!',
        'route': '/chat4'
      },
      {
        'name': '000 멘티',
        'message': '안녕하세요, 쿠버네티스 과정 멘토링 희망합니다!',
        'route': '/chat5'
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        final chat = chatList[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16.0),
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, chat['route']!);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat['name']!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  chat['message']!,
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

  Widget _buildLoginPrompt() {
    return const Center(
      child: Text(
        '로그인 후 이용하실 수 있는 기능입니다.',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    );
  }
}
