import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:http/http.dart' as http;

class GisulChangupCenterPage extends StatefulWidget {
  @override
  _GisulChangupCenterPageState createState() => _GisulChangupCenterPageState();
}

class _GisulChangupCenterPageState extends State<GisulChangupCenterPage> {
  List<Map<String, dynamic>> _data = [];
  WebViewController? _webViewController;
  bool _isWebViewControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      WebView.platform = SurfaceAndroidWebView();
    }
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
      _addMarkersToMap();
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
    }
    return {
      'latitude': 0.0,
      'longitude': 0.0,
    };
  }

  void _addMarkersToMap() {
    if (_isWebViewControllerInitialized) {
      for (var item in _data) {
        final lat = item['위도'];
        final lng = item['경도'];
        final title = item['중장년 기술창업센터명'];
        if (lat != 0.0 && lng != 0.0) {
          _webViewController?.runJavascript('addMarker($lat, $lng, "$title")');
        }
      }
    }
  }

  void _focusOnMarker(double lat, double lng) {
    if (_isWebViewControllerInitialized) {
      _webViewController?.runJavascript('focusOnMarker($lat, $lng)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('재취업 프로그램 살펴보기'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: kIsWeb
                ? Center(child: Text('모바일에서 이용 가능한 기능입니다.'))
                : WebView(
                    initialUrl: 'about:blank',
                    javascriptMode: JavascriptMode.unrestricted,
                    onWebViewCreated: (WebViewController webViewController) {
                      _webViewController = webViewController;
                      _isWebViewControllerInitialized = true;
                      _webViewController?.loadUrl(Uri.dataFromString('''
                        <!DOCTYPE html>
                        <html>
                        <head>
                          <meta charset="utf-8">
                          <title>Kakao Map</title>
                          <style>
                            html, body, #map {
                              width: 100%;
                              height: 100%;
                              margin: 0;
                              padding: 0;
                            }
                          </style>
                          <script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=${dotenv.env['KAKAO_API_JS_KEY']}&autoload=false"></script>
                          <script type="text/javascript">
                            kakao.maps.load(function() {
                              initKakaoMap();
                            });

                            var map;

                            function initKakaoMap() {
                              var mapContainer = document.getElementById('map'),
                                  mapOption = {
                                      center: new kakao.maps.LatLng(37.566535, 126.97796919999996),
                                      level: 3
                                  };
                              map = new kakao.maps.Map(mapContainer, mapOption);
                              window.map = map; // 전역 변수로 설정하여 외부에서 접근 가능하게 함
                              console.log('Kakao Map loaded');
                            }

                            function addMarker(lat, lng, title) {
                              var markerPosition = new kakao.maps.LatLng(lat, lng);
                              var marker = new kakao.maps.Marker({
                                  position: markerPosition,
                                  title: title
                              });
                              marker.setMap(window.map); // 전역 변수 map에 마커를 추가
                              console.log('Marker added at ' + lat + ', ' + lng + ' with title ' + title);
                            }

                            function focusOnMarker(lat, lng) {
                              var moveLatLon = new kakao.maps.LatLng(lat, lng);
                              window.map.setCenter(moveLatLon);
                            }
                          </script>
                        </head>
                        <body>
                          <div id="map"></div>
                        </body>
                        </html>
                      ''',
                              mimeType: 'text/html',
                              encoding: Encoding.getByName('utf-8'))
                          .toString());
                      _addMarkersToMap();
                    },
                  ),
          ),
          Expanded(
            flex: 1,
            child: _data.isEmpty
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
                          onTap: () {
                            _focusOnMarker(item['위도'], item['경도']);
                          },
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
