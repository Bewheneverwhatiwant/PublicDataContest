import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../mypay.dart';

class MyPageMentee extends StatefulWidget {
  @override
  _MyPageMenteeState createState() => _MyPageMenteeState();
}

class _MyPageMenteeState extends State<MyPageMentee>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String> _selectedCategories = [];
  Map<String, dynamic> _menteeInfo = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAndDisplayUserInfo();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('카테고리 선택'),
          children: <Widget>[
            ListTile(
              title: Text('IT'),
              onTap: () {
                _addCategory('IT');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('미용'),
              onTap: () {
                _addCategory('미용');
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _addCategory(String category) {
    if (!_selectedCategories.contains(category)) {
      setState(() {
        _selectedCategories.add(category);
      });
    }
  }

  void _fetchAndDisplayUserInfo() async {
    final String apiServer = dotenv.env['API_SERVER'] ?? '';
    final String? accessToken = await _getAccessToken();

    if (accessToken == null) {
      print('AccessToken not found');
      return;
    }

    final response = await http.get(
      Uri.parse('$apiServer/api/auth/getInfo'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _menteeInfo = responseData;
      });
      print('mentee mypage API call success');
      print(responseData);
    } else {
      print('Failed to fetch user info');
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('멘티님의 마이페이지'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileSection(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profilementee');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalColors.mainColor,
                      ),
                      child: const Text(
                        '프로필 페이지로 이동',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  indicatorColor: GlobalColors.mainColor,
                  labelColor: GlobalColors.mainColor,
                  unselectedLabelColor: GlobalColors.lightgray,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  tabs: const [
                    Tab(text: '구직 정보', icon: Icon(Icons.work_outline)),
                    Tab(text: '내 히스토리', icon: Icon(Icons.history)),
                    Tab(
                        text: '항해 Pay 관리',
                        icon: Icon(Icons.account_balance_wallet)),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildScrollableSection(_buildMenteeInfo(context)),
                        _buildScrollableSection(_buildMentoringHistory()),
                        _buildScrollableSection(MyPaySection()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableSection(Widget child) {
    return SingleChildScrollView(
      child: child,
    );
  }

  Widget _buildSection(Widget child) {
    return SizedBox(
      child: child,
    );
  }

  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('아이디: ${_menteeInfo['mentee']?['userId'] ?? ''}'),
            Text('이름: ${_menteeInfo['mentee']?['menteeName'] ?? ''}'),
            Text('성별: ${_menteeInfo['mentee']?['gender'] ?? ''}'),
            Text('생년월일: ${_menteeInfo['mentee']?['birth'] ?? ''}'),
            Text('이메일: ${_menteeInfo['mentee']?['email'] ?? ''}'),
            Text('전화번호: ${_menteeInfo['mentee']?['phoneNumber'] ?? ''}'),
            Text('주소: ${_menteeInfo['mentee']?['address'] ?? ''}'),
            Text(
                '가입한 날짜: ${_menteeInfo['mentee']?['createdAt']?.substring(0, 10) ?? ''}'),
          ],
        ),
      ],
    );
  }

  Widget _buildMenteeInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('내 구직 분야',
                      style: TextStyle(
                          color: GlobalColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  _selectedCategories.isEmpty
                      ? const Text(
                          '구직 분야를 추가해주세요.',
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _selectedCategories.map((category) {
                            return Text(category);
                          }).toList(),
                        ),
                ],
              ),
            ),
            TextButton(
              onPressed: _showCategoryDialog,
              style: TextButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '추가하기',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 0.5,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text('내 멘티 별점',
                style: TextStyle(
                    color: GlobalColors.mainColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(width: 20),
            Text('아직 받은 별점이 없어요.',
                style: TextStyle(color: GlobalColors.darkgray, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryItem(
      String title, String date, String time, String type) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: GlobalColors.mainColor,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.category, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  type,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentMentorings() {
    const List<Map<String, String>> mentoringHistory = [
      {
        'title': '000멘토링',
        'date': '2023.05.10',
        'mentoringTime': '00:00 ~ 00:00',
        'mentoringType': '멘토링 타입',
      },
      {
        'title': '000멘토링',
        'date': '2023.05.10',
        'mentoringTime': '00:00 ~ 00:00',
        'mentoringType': '멘토링 타입',
      },
      {
        'title': '000멘토링',
        'date': '2023.05.10',
        'mentoringTime': '00:00 ~ 00:00',
        'mentoringType': '멘토링 타입',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mentoringHistory.map((mentoring) {
        return _buildHistoryItem(
          mentoring['title']!,
          mentoring['date']!,
          mentoring['mentoringTime']!,
          mentoring['mentoringType']!,
        );
      }).toList(),
    );
  }

  Widget _buildMentoringHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 멘티 배지',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 16),
        Center(
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Lv.1',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.mainColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '초보 멘티',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GlobalColors.mainColor,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        Text(
          '나의 멘토링 이력',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        _buildRecentMentorings(),
      ],
    );
  }
}
