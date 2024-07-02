import 'package:flutter/material.dart';

class HomeReviewAll extends StatefulWidget {
  const HomeReviewAll({super.key});

  @override
  _HomeReviewAllState createState() => _HomeReviewAllState();
}

class _HomeReviewAllState extends State<HomeReviewAll> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 전체 리뷰'),
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
