import 'package:flutter/material.dart';

class ReviewListPage extends StatefulWidget {
  const ReviewListPage({Key? key}) : super(key: key);

  @override
  _ReviewListPageState createState() => _ReviewListPageState();
}

class _ReviewListPageState extends State<ReviewListPage> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;

  final List<Map<String, dynamic>> _reviews = List.generate(
    20,
    (index) => {
      'content': 'abcde',
      'stars': 5,
      'nickname': 'abcd',
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이 멘토링의 모든 리뷰'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _reviews
                  .skip(_currentPage * _itemsPerPage)
                  .take(_itemsPerPage)
                  .length,
              itemBuilder: (context, index) {
                final review = _reviews[_currentPage * _itemsPerPage + index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16.0),
                      backgroundColor: Colors.orange[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/reviewdetail');
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['content'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: List.generate(review['stars'], (index) {
                            return const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          review['nickname'],
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
                onPressed: (_currentPage + 1) * _itemsPerPage < _reviews.length
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
    );
  }
}
