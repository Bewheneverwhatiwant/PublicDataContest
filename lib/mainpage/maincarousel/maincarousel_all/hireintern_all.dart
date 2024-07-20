import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../appbar/new_appbar.dart';

// 훈련받은 기업 전체보기 화면

class HireInternAll extends StatefulWidget {
  const HireInternAll({super.key});

  @override
  _HireInternAllState createState() => _HireInternAllState();
}

class _HireInternAllState extends State<HireInternAll> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  String _selectedSort = '최신순';
  List<Map<String, String>> _internData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInternData();
  }

  Future<void> _fetchInternData() async {
    setState(() {
      _isLoading = true;
    });

    final serviceKey = dotenv.env['API_COMPANY_KEY_ENCOD'];
    final url = Uri.parse(
        'https://apis.data.go.kr/B490007/hrd4uService1/getBizHrdInfo?serviceKey=$serviceKey&pageNo=1&numOfRows=10');

    try {
      final response = await http.get(url, headers: {
        'accept': '*/*',
      });

      if (response.statusCode == 200) {
        final xmlString = response.body;
        final parsedData = _parseXml(xmlString);
        setState(() {
          _internData = parsedData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to fetch data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error: $e');
    }
  }

  List<Map<String, String>> _parseXml(String xmlString) {
    final document = xml.XmlDocument.parse(xmlString);
    final entries = document.findAllElements('ENTSVC_INFO');
    List<Map<String, String>> parsedData = [];

    for (var entry in entries) {
      final bizNm = entry.findElements('BIZ_NM').single.text;
      final lnmAdres = entry.findElements('LNM_ADRES').single.text;
      final gyejNm = entry.findElements('GYEJ_NM').single.text;

      parsedData.add({
        '사업장명': bizNm,
        '근무지역': lnmAdres,
        '분야': gyejNm,
      });
    }

    return parsedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: const CustomNewAppBar(title: '훈련받은 기업 전체보기'),
      body: Container(
        color: GlobalColors.whiteColor,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6F79F7),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/gisul_changup_center');
                  },
                  child: const Text('중장년 기술창업센터 바로가기',
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('전체보기'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('대분류'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('소분류'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton<String>(
                    value: _selectedSort,
                    items: <String>['최신순', '인기순', '리뷰많은순', '별점순']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSort = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: _internData
                            .skip(_currentPage * _itemsPerPage)
                            .take(_itemsPerPage)
                            .map((intern) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, '/hireinterndetail');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 249, 237),
                                  borderRadius: BorderRadius.circular(15.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              const WidgetSpan(
                                                child: Icon(
                                                  Icons.business,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: ' 사업장명: ',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              TextSpan(
                                                text: intern['사업장명'],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.work,
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' 분야: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: intern['분야'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          const WidgetSpan(
                                            child: Icon(
                                              Icons.location_on,
                                              size: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: ' 근무지역: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text: intern['근무지역'],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: _currentPage > 0
                          ? () {
                              setState(() {
                                _currentPage--;
                              });
                            }
                          : null,
                    ),
                    Text('${_currentPage + 1}'),
                    IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: (_currentPage + 1) * _itemsPerPage <
                              _internData.length
                          ? () {
                              setState(() {
                                _currentPage++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
