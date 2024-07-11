import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoodForeign extends StatefulWidget {
  const GoodForeign({super.key});

  @override
  _GoodForeignState createState() => _GoodForeignState();
}

class _GoodForeignState extends State<GoodForeign> {
  bool _isLoading = true;
  List<Map<String, String>> _jobData = [];

  @override
  void initState() {
    super.initState();
    _fetchJobData();
  }

  Future<void> _fetchJobData() async {
    final serviceKey = dotenv.env['API_GOOD_DECOD'];
    final baseUrl = 'http://apis.data.go.kr/B490007/worldjob30/openApi30';
    final queryParameters = {
      'serviceKey': Uri.encodeQueryComponent(serviceKey!),
      'pageNo': '1',
      'numOfRows': '10',
    };

    final uri = Uri.parse(baseUrl);
    final uriWithQuery = uri.replace(queryParameters: queryParameters);

    // 퍼센트 인코딩된 쿼리에서 + 를 %2B 로 변환
    final encodedQuery = uriWithQuery.query.replaceAll('+', '%2B');
    final urlWithEncodedQuery = uriWithQuery.replace(query: encodedQuery);

    try {
      final response = await http.get(urlWithEncodedQuery, headers: {
        'accept': '*/*',
      });

      if (response.statusCode == 200) {
        final xmlString = response.body;
        print('API 응답 값: $xmlString'); // 응답 값 콘솔 출력
        final parsedData = _parseXml(xmlString);
        setState(() {
          _jobData = parsedData;
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
    final entries = document.findAllElements('item');
    List<Map<String, String>> parsedData = [];

    for (var entry in entries) {
      final title = entry.findElements('rctntcSj').single.text;
      final company = entry.findElements('entNm').single.text;
      final language = entry.findElements('rctntcLang').single.text;

      parsedData.add({
        '공고명': title,
        '회사명': company,
        '필수언어': language,
      });

      // 10개까지만 출력
      if (parsedData.length >= 10) break;
    }

    return parsedData;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '해외취업 우수일자리',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/goodforeignall');
                },
                child: const Text(
                  '전체보기 >',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 150,
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _jobData.length,
                  itemBuilder: (context, index) {
                    final job = _jobData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/jobdetail');
                        },
                        child: Container(
                          width: 200,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 249, 237),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(
                                            Icons.assignment,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            ' 공고명: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              job['공고명'] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                              softWrap: true,
                                              overflow: TextOverflow.clip,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.business,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      ' 회사명: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        job['회사명'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.language,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      ' 필수언어: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        job['필수언어'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black,
                                        ),
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
