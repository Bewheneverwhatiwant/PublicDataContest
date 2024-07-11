import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ForeignMento extends StatefulWidget {
  const ForeignMento({super.key});

  @override
  _ForeignMentoState createState() => _ForeignMentoState();
}

class _ForeignMentoState extends State<ForeignMento> {
  bool _isLoading = true;
  List<Map<String, String>> _mentoData = [];

  @override
  void initState() {
    super.initState();
    _fetchMentoData();
  }

// ENCOD 키로 하면 HTTP ROUTING ERROR가 나고, DECOD로 하면 KEY NOT REGISTERED 오류 나는 중^^!
  Future<void> _fetchMentoData() async {
    final serviceKey = dotenv.env['API_MENTO_FOREIGN_DECOD'];
    //print('해외취업 공공API키: ${serviceKey}');
    final url = Uri.parse(
        'http://apis.data.go.kr/B490007/worldjob18/openApi18?ServiceKey=$serviceKey&pageNo=1&numOfRows=10');

    try {
      final response = await http.get(url, headers: {
        'accept': '*/*',
      });

      if (response.statusCode == 200) {
        final xmlString = response.body;
        print(xmlString);
        final parsedData = _parseXml(xmlString);
        setState(() {
          _mentoData = parsedData;
          _isLoading = false;
        });
      } else {
        print(serviceKey);
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
      final title = entry.findElements('bbscttSj').single.text;
      final url = entry.findElements('bbscttUrl').single.text;
      final author = entry.findElements('questRealmNm').single.text;

      parsedData.add({
        '제목': title,
        'URL': url,
        '작성자': author,
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
                '해외취업 멘토링',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/foreignmentoall');
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
                  itemCount: _mentoData.length,
                  itemBuilder: (context, index) {
                    final mento = _mentoData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/mentodetail');
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
                                            ' 제목: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              mento['제목'] ?? '',
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
                                      Icons.link,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      ' URL: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        mento['URL'] ?? '',
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
                                      Icons.person,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      ' 작성자: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        mento['작성자'] ?? '',
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
