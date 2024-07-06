import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'dart:typed_data'; // 바이너리 데이터를 처리하기 위해 !! (file picker 사용 x)
import 'mypay.dart';

class MyPage extends StatefulWidget {
  final bool isMento;

  const MyPage({Key? key, required this.isMento});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Uint8List> _selectedFiles = [];
  bool isMento = true;
  List<String> _selectedCategories = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isMento = widget.isMento;
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
      } else {
        // User canceled the picker
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  void _toggleRole(bool value) {
    setState(() {
      isMento = value;
    });
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
    // 중복 체크
    if (!_selectedCategories.contains(category)) {
      setState(() {
        _selectedCategories.add(category);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            children: [
              const Text('Mentee'),
              Switch(
                value: isMento,
                onChanged: _toggleRole,
              ),
              const Text('Mentor'),
            ],
          ),
        ],
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
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14), // Adjust font weight and size

              tabs: isMento
                  ? const [
                      Tab(text: '내 멘토링 정보'),
                      Tab(text: '명예의 전당'),
                      Tab(text: '항해 Pay 관리'),
                    ]
                  : const [
                      Tab(text: '구직 정보'),
                      Tab(text: '내 히스토리'),
                      Tab(text: '항해 Pay 관리'),
                    ],
            ),
            SizedBox(
              height: 400,
              child: TabBarView(
                controller: _tabController,
                children: isMento
                    ? [
                        _buildScrollableSection(_buildMentorInfo(context)),
                        _buildScrollableSection(_buildMentoHonor(context)),
                        _buildScrollableSection(MyPaySection()),
                      ]
                    : [
                        _buildScrollableSection(_buildMenteeInfo(context)),
                        _buildScrollableSection(_buildMentoringHistory()),
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

// 상단 프로필 빌드
  Widget _buildProfileSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100, // 예시로 고정 너비 설정
          height: 100, // 예시로 고정 높이 설정
          color: Colors.grey[300],
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('아이디'),
            Text('이름'),
            Text('성별'),
            Text('생년월일'),
            Text('이메일'),
            Text('전화번호'),
            Text('거주지역'),
            Text('현재 재취업 의사'),
            Text('멘토 활동 상태'),
          ],
        ),
      ],
    );
  }

// -----------------------------------------멘토---------------------------------------
// 멘토 - 첫 탭 <내 멘토링 정보>
// 멘토 - 첫 탭 <내 멘토링 정보>
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
                      ? Text(
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
              child: Text(
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
        _buildSection(isMento ? _buildMentoButtons(context) : SizedBox()),
      ],
    );
  }

// 멘토 - 두 번째 탭 <명예의 전당>
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
              Container(color: Colors.grey[300], width: 50, height: 50),
              const SizedBox(width: 5),
              Text('Lv.1'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '내 멘토링 역사',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Text('멘토링 별점: '),
            Text(mentoringRating),
          ],
        ),
        Row(
          children: [
            Text('누적 멘티 수: '),
            Text(accumulatedMenteeCount),
          ],
        ),
        Row(
          children: [
            Text('누적 멘토링 수: '),
            Text(accumulatedMentoringCount),
          ],
        ),
      ],
    );
  }

// 내 멘토링 인증서
  Widget _buildCertificates() {
    // Check if there are no uploaded files
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
                    color: GlobalColors
                        .lightgray, // Optionally, you can change color or style
                  ),
                ),
                Text(
                  '인증서를 등록해야 멘토링을 시작할 수 있어요.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GlobalColors
                        .lightgray, // Optionally, you can change color or style
                  ),
                ),
                // Display previously uploaded images if any
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

  // 멘토 - 하단 버튼 <멘토의 모든 리뷰 보기>
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
              '나의 모든 리뷰 보기',
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

  //----------------------------------여기서부터 멘티--------------------------------------
  //멘티 - 첫 탭 <구직 정보>
  // 멘티 - 첫 탭 <구직 정보>
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
                      ? Text(
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
              child: Text(
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

// 멘티 - 두 번째 탭 <내 히스토리>
  Widget _buildMentoringHistory() {
    String mentoringRating = '별점이 아직 없어요';
    String accumulatedMentoringCount = '0';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '내 멘티 배지',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Center(
          child: Column(
            children: [
              Container(color: Colors.grey[300], width: 50, height: 50),
              const SizedBox(width: 5),
              Text('Lv.1'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '내 멘토링 히스토리',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Row(
          children: [
            Text('멘토링 별점: '),
            Text(mentoringRating),
          ],
        ),
        Row(
          children: [
            Text('누적 멘토링 수: '),
            Text(accumulatedMentoringCount),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          '최근 멘토링 내역',
          style: TextStyle(
            color: GlobalColors.mainColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        _buildRecentMentorings(),
      ],
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
    final Color lightBackgroundColor = Color.fromARGB(255, 236, 242, 255);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: mentoringHistory.map((mentoring) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: lightBackgroundColor,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentoring['title']!,
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
                      mentoring['date']!,
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
                      mentoring['mentoringTime']!,
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
                      mentoring['mentoringType']!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
