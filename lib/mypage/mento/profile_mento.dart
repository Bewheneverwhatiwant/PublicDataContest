import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileMentoPage extends StatefulWidget {
  const ProfileMentoPage({Key? key}) : super(key: key);

  @override
  _ProfileMentoPageState createState() => _ProfileMentoPageState();
}

class _ProfileMentoPageState extends State<ProfileMentoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _mentorId;
  Map<String, dynamic>? _mentorInfo;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMentorId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null && arguments.containsKey('mentorId')) {
        _mentorId = arguments['mentorId'];
        _saveMentorId(_mentorId!);
        _fetchMentorInfo(_mentorId!);
      } else if (_mentorId != null) {
        _fetchMentorInfo(_mentorId!);
      }
    });
  }

  Future<void> _loadMentorId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _mentorId = prefs.getInt('mentorId');
    });
  }

  Future<void> _saveMentorId(int mentorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('mentorId', mentorId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMentorInfo(int mentorId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final url =
        '${dotenv.env['API_SERVER']}/api/auth/getInfo?user_id=$mentorId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _mentorInfo = jsonDecode(response.body)['mentor'];
      });
    } else {
      print('Failed to fetch mentor info');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토 프로필'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: _mentorInfo == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileSection(),
                  const SizedBox(height: 16),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: GlobalColors.mainColor,
                    labelColor: GlobalColors.mainColor,
                    unselectedLabelColor: GlobalColors.lightgray,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: const [Tab(text: '멘토 정보'), Tab(text: '명예의 전당')],
                  ),
                  SizedBox(
                    height: 600, // TabBar 아래 공간은 여기 조정!
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildMentorInfo(),
                        _buildMentorHonor(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileSection() {
    String base64Image = _mentorInfo?['image'] ?? '';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            image: base64Image.isNotEmpty
                ? DecorationImage(
                    image: MemoryImage(base64Decode(base64Image)),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_circle, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('아이디: ${_mentorInfo?['userId']}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.email, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('이메일: ${_mentorInfo?['email']}'),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text('이름: ${_mentorInfo?['mentorName']}'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMentorInfo() {
    List<dynamic> categories = _mentorInfo?['mentorCategoryNames'] ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '인증된 멘토링 분야',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 550, // 그리고 여기
          child: ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              var category = categories[index];
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            '${category['categoryName']} / ${category['subCategoryName']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMentorHonor() {
    String mentoringRating = '별점이 아직 없어요';
    String accumulatedMenteeCount = '0';
    String accumulatedMentoringCount = '0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '멘토의 명예 배지',
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
        SizedBox(height: 16),
        Text(
          '멘토의 멘토링 이력',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
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
                    const Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 8),
                    const Text('멘토링 별점 : '),
                    Text(mentoringRating,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.people, color: GlobalColors.mainColor),
                    const SizedBox(width: 8),
                    const Text('누적 멘티 수: '),
                    Text(accumulatedMenteeCount,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.people, color: GlobalColors.mainColor),
                    const SizedBox(width: 8),
                    const Text('누적 멘토링 수: '),
                    Text(accumulatedMentoringCount,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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
