import 'package:flutter/material.dart';

class MoneyPage extends StatefulWidget {
  const MoneyPage({Key? key}) : super(key: key);

  @override
  _MoneyPageState createState() => _MoneyPageState();
}

class _MoneyPageState extends State<MoneyPage> {
  final List<Map<String, String>> mentoringItems = List.generate(
      10,
      (index) => {
            'title': '쿠버네티스 초급 과정 멘토링 모집합니다.',
            'category': 'IT > 소분류',
            'price': '50,000원',
            'date': '2024.07.01',
            'rating': '5/5',
          });

  int _currentPage = 1;
  final int _itemsPerPage = 6;
  String _selectedOrder = '최신순';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 리스트'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryButtons(),
            const SizedBox(height: 16),
            _buildOrderDropdown(),
            const SizedBox(height: 16),
            Expanded(child: _buildMentoringList()),
            _buildPaginationControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('전체보기')),
        ElevatedButton(onPressed: () {}, child: const Text('대분류')),
        ElevatedButton(onPressed: () {}, child: const Text('소분류')),
      ],
    );
  }

  Widget _buildOrderDropdown() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DropdownButton<String>(
          value: _selectedOrder,
          onChanged: (String? newValue) {
            setState(() {
              _selectedOrder = newValue!;
            });
          },
          items: <String>['최신순', '인기순', '리뷰많은순', '별점순']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMentoringList() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (_currentPage * _itemsPerPage);
    final currentItems = mentoringItems.sublist(
      startIndex,
      endIndex > mentoringItems.length ? mentoringItems.length : endIndex,
    );

    return ListView.builder(
      itemCount: currentItems.length,
      itemBuilder: (context, index) {
        final item = currentItems[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/mentoringdetail');
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(item['category']!),
                  const SizedBox(height: 4),
                  Text('가격: ${item['price']}'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['date']!,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        item['rating']!,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaginationControls() {
    final totalPages = (mentoringItems.length / _itemsPerPage).ceil();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
        ),
        Text('$_currentPage / $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: _currentPage < totalPages
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
