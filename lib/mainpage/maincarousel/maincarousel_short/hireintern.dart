import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HireIntern extends StatefulWidget {
  const HireIntern({super.key});

  @override
  _HireInternState createState() => _HireInternState();
}

class _HireInternState extends State<HireIntern> {
  bool _isLoading = true;
  List<Map<String, String>> _internData = [];

  @override
  void initState() {
    super.initState();
    _fetchInternData();
  }

  Future<void> _fetchInternData() async {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '근로복지 훈련을 받은 기업',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/hireinternall');
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
                  itemCount: _internData.length,
                  itemBuilder: (context, index) {
                    final intern = _internData[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/hireinterndetail');
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
                                            Icons.business,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 4),
                                          const Text(
                                            ' 사업장명: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              intern['사업장명'] ?? '',
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: const Text(
                                        'D - n',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color.fromARGB(
                                                255, 239, 99, 24),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.work,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      ' 분야: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        intern['분야'] ?? '',
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
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      ' 근무지역: ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        intern['근무지역'] ?? '',
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
