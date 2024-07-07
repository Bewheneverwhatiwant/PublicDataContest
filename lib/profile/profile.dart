import 'package:flutter/material.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';

class ProfilePage extends StatefulWidget {
  final bool isMento;

  const ProfilePage({Key? key, required this.isMento}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isMento = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    isMento = widget.isMento;
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
        title: Text('프로필'),
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
              tabs: isMento
                  ? const [Tab(text: '멘토 정보'), Tab(text: '명예의 전당')]
                  : const [Tab(text: '멘티 정보'), Tab(text: '명예의 전당')],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: isMento
                    ? [_buildMentorInfo(), _buildMentorHonor()]
                    : [_buildMenteeInfo(), _buildMenteeHonor()],
              ),
            ),
            _buildSection(isMento ? _buildMentoButtons(context) : SizedBox()),
          ],
        ),
      ),
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

  Widget _buildMentorInfo() {
    List<String> subcategories = ['IT', '경영', '마케팅'];

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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: subcategories.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
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
                      SizedBox(width: 16),
                      Text(
                        '소분류${index + 1}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
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
                    Text(accumulatedMenteeCount,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.people, color: GlobalColors.mainColor),
                    SizedBox(width: 8),
                    Text('누적 멘토링 수: '),
                    Text(accumulatedMentoringCount,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMentoButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/allmentorreview');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: GlobalColors.mainColor,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '이 멘토에 대한 리뷰 보기',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
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
