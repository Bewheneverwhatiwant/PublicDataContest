import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MentoCertificate extends StatefulWidget {
  @override
  _MentoCertificateState createState() => _MentoCertificateState();
}

class _MentoCertificateState extends State<MentoCertificate> {
  int? mentorId;
  List<String> certificates = [];

  @override
  void initState() {
    super.initState();
    fetchMentorInfo();
  }

  Future<void> fetchMentorInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final apiServer = dotenv.env['API_SERVER'] ?? '';
    final url = '$apiServer/api/auth/getInfo';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        mentorId = responseData['mentor']['mentorId'];
      });
      fetchCertificates();
    } else {
      print('Failed to fetch mentor info');
    }
  }

  Future<void> fetchCertificates() async {
    if (mentorId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final apiServer = dotenv.env['API_SERVER'] ?? '';
    final url =
        '$apiServer/api/certificates/get_certificate?mentor_id=$mentorId';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('인증서 API 호출 성공');
      final responseData = json.decode(response.body);
      //print('응답 데이터: $responseData');

      setState(() {
        certificates =
            List<String>.from(responseData.map((cert) => cert['image']));
      });
    } else {
      print('인증서 API 호출 실패');
      print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: certificates.map((image) {
          try {
            final decodedImage = base64Decode(image);
            return Container(
              width: 100,
              height: 200,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Image.memory(
                decodedImage,
                fit: BoxFit.cover,
              ),
            );
          } catch (e) {
            print('이미지 디코딩 오류: $e');
            return Container(
              width: 100,
              height: 200,
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(child: Text('이미지 오류')),
            );
          }
        }).toList(),
      ),
    );
  }
}
