import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';

class ProfileMenteePage extends StatefulWidget {
  const ProfileMenteePage({Key? key}) : super(key: key);

  @override
  _ProfileMenteePageState createState() => _ProfileMenteePageState();
}

class _ProfileMenteePageState extends State<ProfileMenteePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('멘티 프로필'),
      ),
      body: SingleChildScrollView(
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
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
            Row(
              children: [
                Icon(Icons.account_circle, size: 20, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('아이디: happyUser2024'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.email, size: 20, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('이메일: user123@example.com'),
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
        SizedBox(height: 16),
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
