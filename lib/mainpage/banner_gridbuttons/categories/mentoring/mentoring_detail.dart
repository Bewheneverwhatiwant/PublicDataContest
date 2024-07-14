import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MentoringDetailPage extends StatefulWidget {
  const MentoringDetailPage({Key? key}) : super(key: key);

  @override
  _MentoringDetailPageState createState() => _MentoringDetailPageState();
}

class _MentoringDetailPageState extends State<MentoringDetailPage> {
  Map<String, dynamic> mentoringDetail = {};
  bool _isLoading = true;
  bool _hasError = false;
  int? _classId;
  int? _mentorId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

      if (arguments != null &&
          arguments.containsKey('classId') &&
          arguments.containsKey('mentorId')) {
        _classId = arguments['classId'];
        _mentorId = arguments['mentorId'];

        _saveClassId(_classId!);
        _saveMentorId(_mentorId!);
      }
      _loadClassIdAndMentorIdAndFetchDetail();
    });
  }

  Future<void> _saveClassId(int classId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('classId', classId);
  }

  Future<void> _saveMentorId(int mentorId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mentorId', mentorId);
  }

  Future<void> _loadClassIdAndMentorIdAndFetchDetail() async {
    if (_classId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _classId = prefs.getInt('classId');
    }
    if (_mentorId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _mentorId = prefs.getInt('mentorId');
    }
    if (_classId != null) {
      _fetchMentoringDetail(_classId!);
    } else {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _fetchMentoringDetail(int classId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['API_SERVER']}/api/mentoring/mentoring_detail?classId=$classId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          mentoringDetail = json.decode(response.body);
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
    }
  }

  Future<void> createChatRoom(int mentorId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final role = prefs.getString('role') ?? '';

    if (role != 'mentee') {
      _showRoleAlert(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(
            '${dotenv.env['API_SERVER']}/api/chat/make_chat?mentorId=$mentorId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final conversationId = responseData['conversationId'];
        final isAlready = responseData['isAlready'];
        final mentorName = mentoringDetail['mentorName'] ?? '멘토 이름 없음';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(isAlready ? '이미 이 멘토와의 채팅방이 존재합니다.' : '이 멘토와 채팅을 시작합니다!'),
            duration: const Duration(seconds: 1),
          ),
        );

        Navigator.pushNamed(
          context,
          '/classchat',
          arguments: {
            'conversationId': conversationId,
            'classId': _classId,
            'titlename': mentorName,
          },
        );
        print('넘겨진 conversationId: $conversationId');
        print('넘겨진 멘토 id: $mentorId');
        print('넘겨진 classId: $_classId');
      } else {
        print('채팅방 생성 실패');
        print(mentorId);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  void _showRoleAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('멘티만 채팅방 생성이 가능합니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: const Text('멘토링 상세 설명'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Center(child: Text('오류가 발생했습니다.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCategorySection(),
                      const SizedBox(height: 16),
                      _buildMentoringInfo(context),
                      const SizedBox(height: 16),
                      _buildLikeAndChat(context),
                    ],
                  ),
                ),
    );
  }

  Widget _buildCategorySection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${mentoringDetail['categoryName']}/${mentoringDetail['subcategoryName']}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          mentoringDetail['active'] ? '진행 중' : '진행 종료',
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildMentoringInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mentoringDetail['name'] ?? '멘토링 이름 없음',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/profilemento');
                },
                icon: const Icon(Icons.person, color: Colors.yellow),
                label: Text(mentoringDetail['mentorName'] ?? '멘토 이름 없음'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star, color: Colors.yellow),
              const SizedBox(width: 4),
              const Text('4.5/5'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/review_list_template',
                    arguments: {'reviewlistkind': 2},
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  '리뷰(32)',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            mentoringDetail['description'] ?? '설명 없음',
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('멘토링 이름: ${mentoringDetail['name'] ?? '없음'}'),
                  Text('멘토링 희망 지역: ${mentoringDetail['location'] ?? '없음'}'),
                  Text('멘토링 시간: 1회당 최대 ${mentoringDetail['time'] ?? '없음'} 분'),
                  Text('멘토링 가격: ${mentoringDetail['price'] ?? '없음'}원'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLikeAndChat(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.blue),
              onPressed: () async {
                bool isLoggedIn = await _checkIfLoggedIn();
                if (isLoggedIn) {
                  // 좋아요 버튼 클릭 시
                } else {
                  _showLoginAlert(context);
                }
              },
            ),
            const Text('좋아요 2개'),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () async {
            bool isLoggedIn = await _checkIfLoggedIn();
            if (isLoggedIn) {
              if (_mentorId != null) {
                await createChatRoom(_mentorId!);
              }
            } else {
              _showLoginAlert(context);
            }
          },
          icon: const Icon(Icons.chat_bubble_outline),
          label: const Text('멘토와의 채팅'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<bool> _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('accessToken');
    return accessToken != null;
  }

  void _showLoginAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('로그인 후 이용하실 수 있는 기능입니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
