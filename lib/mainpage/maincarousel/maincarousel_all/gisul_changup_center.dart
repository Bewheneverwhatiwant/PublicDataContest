import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GisulChangupCenterPage extends StatefulWidget {
  @override
  _GisulChangupCenterPageState createState() => _GisulChangupCenterPageState();
}

class _GisulChangupCenterPageState extends State<GisulChangupCenterPage> {
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response = await http.get(
      Uri.parse(
        'https://api.odcloud.kr/api/3037863/v1/uddi:9693cfa7-518a-4fb4-827d-ecef1fb93781',
      ).replace(
        queryParameters: {
          'page': '1',
          'perPage': '10',
          'serviceKey': dotenv.env['API_KEY_DECODING'],
          'returnType': 'JSON',
        },
      ),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(responseData); // 응답 데이터를 출력하여 구조 확인
      setState(() {
        _data = responseData['data'];
      });
    } else {
      print('Failed to fetch data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재취업 프로그램 살펴보기'),
      ),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: _data.map((item) {
                  return ListTile(
                    title: Text(item['중장년 기술창업센터명'] ?? 'No Name'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('지역: ${item['지역'] ?? 'No Region'}'),
                        Text('주소지: ${item['주소지'] ?? 'No Address'}'),
                        Text('연락처: ${item['연락처'] ?? 'No Contact'}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
