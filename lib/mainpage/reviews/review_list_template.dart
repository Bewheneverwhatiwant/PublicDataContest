import 'package:flutter/material.dart';

// 리뷰 리스트 화면 템플릿 정의
// 1: 그냥 모든 멘토링에 대한 리뷰 리스트, 2: 특정 멘토링에 대한 리뷰 리스트, 3: 특정 멘토에 대한 리뷰 리스트

class ReviewListTemplatePage extends StatefulWidget {
  const ReviewListTemplatePage({super.key});

  @override
  _ReviewListTemplatePageState createState() => _ReviewListTemplatePageState();
}

class _ReviewListTemplatePageState extends State<ReviewListTemplatePage> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  String _selectedSort = '최신순';

  final List<Map<String, dynamic>> _reviewData = List.generate(
    20,
    (index) => {
      '멘토링명': '어쩌구',
      '멘토': '어쩌구',
      '별수': 5,
      '설명': 'abcd',
    },
  );

  final Map<int, String> appBarTitles = {
    1: '모든 멘토링 리스트',
    2: '특정 멘토링에 대한 모든 리뷰',
    3: '특정 멘토에 대한 모든 리뷰',
  };

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final int reviewlistkind = arguments['reviewlistkind'];
    final String appBarTitle = appBarTitles[reviewlistkind] ?? '리뷰 리스트';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
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
              ..._reviewData
                  .skip(_currentPage * _itemsPerPage)
                  .take(_itemsPerPage)
                  .map((review) {
                final int stars = review['별수'] as int;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/reviewdetail');
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
                            '멘토링명: ${review['멘토링명']}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '멘토: ${review['멘토']}',
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
                            review['설명'],
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
