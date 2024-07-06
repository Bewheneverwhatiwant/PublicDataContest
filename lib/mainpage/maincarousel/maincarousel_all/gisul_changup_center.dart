import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GisulChangupCenterPage extends StatefulWidget {
  @override
  _GisulChangupCenterPageState createState() => _GisulChangupCenterPageState();
}

class _GisulChangupCenterPageState extends State<GisulChangupCenterPage> {
  List<Map<String, dynamic>> _data = [];

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
      List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(responseData['data']);
      for (var item in data) {
        final latLng = await _getLatLong(item['주소지']);
        item['위도'] = latLng['latitude'];
        item['경도'] = latLng['longitude'];
      }
      setState(() {
        _data = data;
      });
    } else {
      print('Failed to fetch data');
    }
  }

  Future<Map<String, double>> _getLatLong(String address) async {
    final apiKey = dotenv.env['KAKAO_API_KEY'];
    final url =
        'https://dapi.kakao.com/v2/local/search/address.json?query=$address';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'KakaoAK $apiKey',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['documents'].isNotEmpty) {
        final document = data['documents'][0];
        return {
          'latitude': double.parse(document['y']),
          'longitude': double.parse(document['x']),
        };
      }
    } else {
      print('Failed to fetch coordinates for $address');
      print(apiKey);
    }
    return {
      'latitude': 0.0,
      'longitude': 0.0,
    };
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
                        Text('위도: ${item['위도']}'),
                        Text('경도: ${item['경도']}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}
