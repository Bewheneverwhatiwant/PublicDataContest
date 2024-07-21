import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileMenteePage extends StatefulWidget {
  const ProfileMenteePage({Key? key}) : super(key: key);

  @override
  _ProfileMenteePageState createState() => _ProfileMenteePageState();
}

class _ProfileMenteePageState extends State<ProfileMenteePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int? _menteeId;
  Map<String, dynamic>? _menteeInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (arguments != null && arguments.containsKey('menteeId')) {
        _menteeId = arguments['menteeId'];
        print('받은 menteeId는 $_menteeId');
        _fetchMenteeInfo(_menteeId!);
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchMenteeInfo(int menteeId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final url =
        '${dotenv.env['API_SERVER']}/api/auth/getInfo?user_id=$menteeId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _menteeInfo = jsonDecode(response.body)['mentee'];
          _isLoading = false;
        });
        print('받은 menteeInfo는 $_menteeInfo');
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to fetch mentee info: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching mentee info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text('멘티 프로필'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _menteeInfo == null
              ? Center(child: Text('멘티 정보를 불러올 수 없습니다.'))
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
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        tabs: const [Tab(text: '멘티 정보'), Tab(text: '명예의 전당')],
                      ),
                      SizedBox(
                        height: 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [_buildMenteeInfo(), _buildMenteeHonor()],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileSection() {
    String base64Image = _menteeInfo?['image'] ?? '';
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_circle, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('아이디: ${_menteeInfo?['userId']}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text('이메일: ${_menteeInfo?['email']}'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenteeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '구직 분야',
            style: TextStyle(
              color: GlobalColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            'IT 개발자',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '멘티로서의 별점',
            style: TextStyle(
              color: GlobalColors.mainColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
            5,
            (index) => Icon(
              Icons.star,
              color: Color.fromARGB(255, 255, 208, 0),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenteeHonor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '멘티의 명예 배지',
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
      ],
    );
  }
}
