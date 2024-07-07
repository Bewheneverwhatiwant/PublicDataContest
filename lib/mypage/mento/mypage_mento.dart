import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../mypay.dart';

class MyPageMento extends StatefulWidget {
  const MyPageMento({Key? key}) : super(key: key);

  @override
  _MyPageMentoState createState() => _MyPageMentoState();
}

class _MyPageMentoState extends State<MyPageMento>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Uint8List> _selectedFiles = [];
  List<String> _selectedCategories = [];
  Map<String, dynamic> _mentorInfo = {};

  String userId = '';
  String mentorName = '';
  String gender = '';
  String birth = '';
  String email = '';
  String phoneNumber = '';
  String address = '';
  String createdAt = '';
  int studentCount = 0;
  int mentoringCount = 0;
  String reemploymentIdea = '';
  String active = '';

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

  void _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null) {
        setState(() {
          _selectedFiles
              .addAll(result.files.map((file) => file.bytes!).toList());
        });
      } else {}
    } catch (e) {
      print('Error picking files: $e');
    }
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
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _parseAndDisplayUserInfo(responseData);
    } else {
      print('Failed to fetch user info');
    }
  }

  void _parseAndDisplayUserInfo(Map<String, dynamic> responseData) {
    var mentor = responseData['mentor'];
    var role = responseData['role'];

    setState(() {
      userId = mentor['userId'];
      mentorName = mentor['mentorName'];
      gender = mentor['gender'];
      birth = mentor['birth'];
      email = mentor['email'];
      phoneNumber = mentor['phoneNumber'];
      address = mentor['address'];
      // 날짜 형식 변환
      DateTime createdAtDate = DateTime.parse(mentor['createdAt']);
      createdAt =
          '${createdAtDate.year}.${createdAtDate.month}.${createdAtDate.day}';
      studentCount = mentor['studentCount'] ?? 0;
      mentoringCount = mentor['mentoringCount'] ?? 0;
      reemploymentIdea = mentor['reemploymentIdea'] ? '있음' : '없음';
      active = mentor['active'] == null ? '활동 쉬는 중' : '활동 중';
    });
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('멘토 마이페이지'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profilemento');
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
                Tab(text: '내 멘토링 정보', icon: Icon(Icons.info_outline)),
                Tab(text: '명예의 전당', icon: Icon(Icons.star_border)),
                Tab(
                    text: '항해 Pay 관리',
                    icon: Icon(Icons.account_balance_wallet)),
              ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildScrollableSection(_buildMentorInfo(context)),
                  _buildScrollableSection(_buildMentoHonor(context)),
                  _buildScrollableSection(MyPaySection()),
                ],
              ),
            ),
          ],
        ),
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
            Text('아이디: $userId'),
            Text('이름: $mentorName'),
            Text('성별: $gender'),
            Text('생년월일: $birth'),
            Text('이메일: $email'),
            Text('전화번호: $phoneNumber'),
            Text('주소: $address'),
            Text('가입한 날짜: $createdAt'),
            Text('현재 재취업 의사: $reemploymentIdea'),
            Text('멘토 활동 상태: $active'),
          ],
        ),
      ],
    );
  }

  Widget _buildMentorInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('내 멘토링 분야',
                      style: TextStyle(
                          color: GlobalColors.mainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  _selectedCategories.isEmpty
                      ? const Text(
                          '멘토링 분야를 추가해주세요.',
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
        Text('내 멘토링 인증서',
            style: TextStyle(
                color: GlobalColors.mainColor,
                fontWeight: FontWeight.bold,
                fontSize: 16)),
        const SizedBox(height: 8),
        _buildCertificates(),
        const SizedBox(height: 16),
        _buildSection(_buildMentoButtons(context)),
      ],
    );
  }

  Widget _buildCertificates() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickFile,
                  child: Container(
                    width: 100,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const Icon(Icons.add, size: 40, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  '아직 등록한 인증서가 없어요.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.lightgray,
                  ),
                ),
                Text(
                  '인증서를 등록해야 멘토링을 시작할 수 있어요.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GlobalColors.lightgray,
                  ),
                ),
                ..._selectedFiles.map((file) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Image.memory(
                        file,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentoButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/review_list_template',
                  arguments: {'reviewlistkind': 3},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '나의 모든 리뷰 보기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/mentomyclass');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalColors.mainColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '나의 모든 멘토링 관리하기',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildMentoHonor(BuildContext context) {
    String mentoringRating = '별점이 아직 없어요';
    String accumulatedMenteeCount = '0';
    String accumulatedMentoringCount = '0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 명예 배지',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
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
                '초보 멘토',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GlobalColors.mainColor,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    Text('멘토링 별점 : '),
                    Text(mentoringRating,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people, color: GlobalColors.mainColor),
                    SizedBox(width: 8),
                    Text('누적 멘티 수: '),
                    Text('${_mentorInfo['mentor']?['studentCount'] ?? 0}'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.people, color: GlobalColors.mainColor),
                    SizedBox(width: 8),
                    Text('누적 멘토링 수: '),
                    Text('${_mentorInfo['mentor']?['mentoringCount'] ?? 0}'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
