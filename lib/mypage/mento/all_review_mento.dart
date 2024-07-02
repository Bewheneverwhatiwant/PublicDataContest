import 'package:flutter/material.dart';

class AllMentorReviewPage extends StatefulWidget {
  const AllMentorReviewPage({Key? key}) : super(key: key);

  @override
  _AllMentorReviewPageState createState() => _AllMentorReviewPageState();
}

class _AllMentorReviewPageState extends State<AllMentorReviewPage> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  final List<Map<String, dynamic>> reviews = [
    {'description': 'abcde', 'stars': 5, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 4, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 5, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 3, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 5, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 4, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 5, 'user': 'abcd'},
    {'description': 'abcde', 'stars': 3, 'user': 'abcd'},
  ];

  String _selectedSort = '최신순';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이 멘토의 모든 리뷰'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: DropdownButton<String>(
                value: _selectedSort,
                items: <String>['최신순', '별점순'].map((String value) {
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
            ..._buildReviewItems(),
            const SizedBox(height: 16),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReviewItems() {
    final start = _currentPage * _itemsPerPage;
    final end = start + _itemsPerPage;
    final currentReviews =
        reviews.sublist(start, end > reviews.length ? reviews.length : end);

    return currentReviews.map((review) {
      return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, '/reviewdetail');
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review['description'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    review['stars'],
                    (index) => const Icon(Icons.star, color: Colors.yellow),
                  ),
                ),
                const SizedBox(height: 8),
                Text(review['user']),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPaginationControls() {
    final totalPages = (reviews.length / _itemsPerPage).ceil();
    return Row(
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
        Text('${_currentPage + 1} / $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: _currentPage < totalPages - 1
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
