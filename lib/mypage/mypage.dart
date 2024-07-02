import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data'; // 바이너리 데이터를 처리하기 위해 !! (file picker 사용 x)
import 'mypay.dart';

class MyPage extends StatefulWidget {
  final bool isMento;

  const MyPage({super.key, required this.isMento});

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  List<Uint8List> _selectedFiles = [];

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
        // 사용자가 파일 선택 취소
      }
    } catch (e) {
      print('파일 선택 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 16),
            widget.isMento
                ? _buildMentorSection(context)
                : _buildMenteeSection(context),
            const SizedBox(height: 16),
            _buildPaySection(),
            const SizedBox(height: 16),
            _buildButtons(context),
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
          color: Colors.grey[300],
          width: 100,
          height: 100,
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('아이디'),
            Text('닉네임'),
            Text('이름 / 성별'),
            Text('생년월일'),
            Text('이메일'),
            Text('전화번호'),
            Text('거주지역'),
            Text('현재 재취업 의사 yes/no'),
            Text('멘토 활동 상태 on/off'),
          ],
        ),
      ],
    );
  }

  Widget _buildMentorSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('내 멘토링 정보', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            const Expanded(child: Text('내 멘토링 분야 대분류/소분류')),
            TextButton(onPressed: () {}, child: const Text('추가하기')),
          ],
        ),
        const SizedBox(height: 16),
        const Text('내 멘토링 인증서',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildCertificates(),
        const SizedBox(height: 16),
        const Text('내 명예 배지', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Container(color: Colors.grey[300], width: 50, height: 50),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 50, height: 50),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 50, height: 50),
          ],
        ),
        const SizedBox(height: 16),
        const Text('내 멘토링 역사', style: TextStyle(fontWeight: FontWeight.bold)),
        const Text('멘토링 별점'),
        const Text('현재 멘티 수'),
        const Text('누적 멘티'),
        const Text('취업에 성공한 멘티 수'),
        const Text('누적 멘토링 수익'),
      ],
    );
  }

  Widget _buildCertificates() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
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
          const SizedBox(width: 8),
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
    );
  }

  Widget _buildMenteeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('내 구직 정보', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            const Expanded(child: Text('내 구직 분야 대분류/소분류')),
            TextButton(onPressed: () {}, child: const Text('추가하기')),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Text('멘토로서 나의 별점'),
            const SizedBox(width: 8),
            Row(
                children: List.generate(5,
                    (index) => const Icon(Icons.star, color: Colors.yellow))),
          ],
        ),
        const SizedBox(height: 16),
        const Text('내 명예 배지', style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Container(color: Colors.grey[300], width: 50, height: 50),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 50, height: 50),
            const SizedBox(width: 8),
            Container(color: Colors.grey[300], width: 50, height: 50),
          ],
        ),
        const SizedBox(height: 16),
        const Text('나의 모든 멘토링 내역',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _buildMentoringHistory(),
      ],
    );
  }

  Widget _buildMentoringHistory() {
    const List<Map<String, String>> mentoringHistory = [
      {
        'title': '000멘토 | 000멘토링',
        'date': '2024.6.1~2024.7.1',
        'price': '50,000'
      },
      {
        'title': '000멘토 | 000멘토링',
        'date': '2024.6.1~2024.7.1',
        'price': '50,000'
      },
      {
        'title': '000멘토 | 000멘토링',
        'date': '2024.6.1~2024.7.1',
        'price': '50,000'
      },
    ];

    return Column(
      children: mentoringHistory.map((history) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(history['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(history['date']!),
                Text(history['price']!),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPaySection() {
    return const MyPaySection();
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        if (widget.isMento)
          SizedBox(
            width: 250,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/mentomyclass');
              },
              child: const Text('나의 모든 멘토링 관리'),
            ),
          ),
        SizedBox(height: 10),
        SizedBox(
          width: 250,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(
                  context, widget.isMento ? '/profilemento' : '/profilementi');
            },
            child: Text(widget.isMento ? '멘티가 볼 나의 프로필 보기' : '멘토가 볼 나의 프로필 보기'),
          ),
        ),
      ],
    );
  }
}
