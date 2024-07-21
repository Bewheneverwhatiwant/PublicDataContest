import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 리뷰 리스트 화면 템플릿 정의
// 1: 그냥 모든 멘토링에 대한 리뷰 리스트, 2: 특정 멘토링에 대한 모든 리뷰 리스트, 3: 특정 멘토에 대한 모든 리뷰 리스트

class ReviewListTemplatePage extends StatefulWidget {
  const ReviewListTemplatePage({super.key});

  @override
  _ReviewListTemplatePageState createState() => _ReviewListTemplatePageState();
}

class _ReviewListTemplatePageState extends State<ReviewListTemplatePage> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  String _selectedSort = '최신순';
  List<Map<String, dynamic>> _reviewData = [];
  int? _classId;

  final Map<int, String> appBarTitles = {
    1: '모든 멘토링 리스트',
    2: '특정 멘토링에 대한 모든 리뷰',
    3: '특정 멘토에 대한 모든 리뷰 리스트',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final int reviewlistkind = arguments?['reviewlistkind'] ?? 1;
      _classId = arguments?['classId'];
      print('전달받은 classId: $_classId');

      if (reviewlistkind == 1) {
        _fetchAllReviews();
      } else if (reviewlistkind == 2 && _classId != null) {
        _saveClassId(_classId!);
        _fetchReviews(_classId!);
      } else {
        _loadClassIdAndFetchReviews();
      }
    });
  }

  Future<void> _saveClassId(int classId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('classId', classId);
  }

  Future<void> _loadClassIdAndFetchReviews() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _classId = prefs.getInt('classId');
    if (_classId != null) {
      _fetchReviews(_classId!);
    } else {
      setState(() {
        // classId가 null일 경우 처리
        print('Error: classId is null');
      });
    }
  }

  Future<void> _fetchAllReviews() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_SERVER']}/api/review'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        setState(() {
          _reviewData =
              responseData.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        // Error handling
        print('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      // Error handling
      print('Error fetching reviews: $e');
    }
  }

  Future<void> _fetchReviews(int classId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
            '${dotenv.env['API_SERVER']}/api/review/class?classId=$classId'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List;
        setState(() {
          _reviewData =
              responseData.map((item) => item as Map<String, dynamic>).toList();
        });
      } else {
        // Error handling
        print('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      // Error handling
      print('Error fetching reviews: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map? arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    final int reviewlistkind = arguments?['reviewlistkind'] ?? 1;
    final String appBarTitle = appBarTitles[reviewlistkind] ?? '리뷰 리스트';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              if (_reviewData.isEmpty)
                const Text('리뷰가 없습니다.')
              else
                ..._reviewData
                    .skip(_currentPage * _itemsPerPage)
                    .take(_itemsPerPage)
                    .map((review) {
                  final String className = review['className'] ?? '없음';
                  final String comment = review['comment'] ?? '코멘트 없음';
                  final int stars = review['rating'] ?? 0;
                  final int reviewId = review['reviewId'] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/reviewdetail',
                          arguments: {'reviewId': reviewId},
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '멘토링명: $className',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review['comment'] ?? '설명 없음',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: List.generate(stars, (index) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                );
                              }),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '내가 준 별점: $stars 점',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
                    onPressed:
                        (_currentPage + 1) * _itemsPerPage < _reviewData.length
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
    );
  }
}
