import 'package:flutter/material.dart';
import '../../appbar/new_appbar.dart';

class HireInternAll extends StatefulWidget {
  const HireInternAll({super.key});

  @override
  _HireInternAllState createState() => _HireInternAllState();
}

class _HireInternAllState extends State<HireInternAll> {
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  String _selectedSort = '최신순';

  final List<Map<String, String>> _internData = List.generate(
    20,
    (index) => {'사업장명': 'abcd', '모집직종': 'abcd', '근무지역': 'abcd'},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomNewAppBar(title: '인턴 채용공고 전체보기'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: const Text('미정'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('전체보기'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('대분류'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('소분류'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              ..._internData
                  .skip(_currentPage * _itemsPerPage)
                  .take(_itemsPerPage)
                  .map((intern) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '사업장명: ${intern['사업장명']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'D-n',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '모집직종: ${intern['모집직종']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '근무지역: ${intern['근무지역']}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
                        (_currentPage + 1) * _itemsPerPage < _internData.length
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
