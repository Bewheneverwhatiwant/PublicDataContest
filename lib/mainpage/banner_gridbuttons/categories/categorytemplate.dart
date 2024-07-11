import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryTemplatePage extends StatefulWidget {
  const CategoryTemplatePage({Key? key}) : super(key: key);

  @override
  _CategoryTemplatePageState createState() => _CategoryTemplatePageState();
}

class _CategoryTemplatePageState extends State<CategoryTemplatePage> {
  final List<Map<String, dynamic>> mentoringItems = [];
  final Map<int, String> categoryNames = {
    1: '전체',
    2: '언어',
    3: '회계',
    4: 'IT',
    5: '디자인',
    6: '음악',
    7: '미용',
    8: '사진',
    9: '기획',
    10: '공예',
  };

  int _currentPage = 1;
  final int _itemsPerPage = 6;
  String _selectedOrder = '최신순';
  bool _isLoading = true;
  bool _hasError = false;
  int _categoryKind = 1;
  int? _selectedCategoryId;
  int? _selectedSubCategoryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
              {'kind': 1};
      setState(() {
        _categoryKind = arguments['kind'] ?? 1;
      });
      _fetchMentoringList();
    });
  }

  Future<void> _fetchMentoringList() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final category = categoryNames[_categoryKind] ?? '전체';

    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_SERVER']}/api/mentoring/mentoring_list'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          mentoringItems.clear();
          mentoringItems.addAll(
            data.where((dynamic item) {
              if (item is Map<String, dynamic>) {
                if (category == '전체') {
                  return true;
                } else {
                  return item['categoryName'] == category;
                }
              }
              return false;
            }).map<Map<String, dynamic>>((dynamic item) {
              String formattedDate = _formatDate(item['createdAt']);
              return {
                'classId': item['classId'],
                'mentorId': item['mentorId'],
                'title': item['name']?.toString() ?? 'No Title',
                'category': item['categoryName']?.toString() ?? 'No Category',
                'price': '${item['price'] ?? 0}원',
                'date': formattedDate,
              };
            }).toList(),
          );

          // date 기준으로 내림차순 정렬
          mentoringItems.sort((a, b) => b['date'].compareTo(a['date']));

          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _fetchFilteredList(int? categoryId, int? subCategoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final String apiUrl;

    if (categoryId != null) {
      apiUrl =
          '${dotenv.env['API_SERVER']}/api/mentoring/category_filtering?categoryId=$categoryId';
    } else if (subCategoryId != null) {
      apiUrl =
          '${dotenv.env['API_SERVER']}/api/mentoring/subCategory_filtering?subCategoryId=$subCategoryId';
    } else {
      apiUrl = '${dotenv.env['API_SERVER']}/api/mentoring/mentoring_list';
    }

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          mentoringItems.clear();
          mentoringItems.addAll(
            data.map<Map<String, dynamic>>((dynamic item) {
              String formattedDate = _formatDate(item['createdAt']);
              return {
                'classId': item['classId'],
                'mentorId': item['mentorId'],
                'title': item['name']?.toString() ?? 'No Title',
                'category': item['categoryName']?.toString() ?? 'No Category',
                'price': '${item['price'] ?? 0}원',
                'date': formattedDate,
              };
            }).toList(),
          );

          // date 기준으로 내림차순 정렬
          mentoringItems.sort((a, b) => b['date'].compareTo(a['date']));

          _isLoading = false;
          _hasError = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  String _formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return '${parsedDate.year}년${parsedDate.month.toString().padLeft(2, '0')}월${parsedDate.day.toString().padLeft(2, '0')}일';
  }

  Future<List<dynamic>> _fetchCategories() async {
    final String apiServer = dotenv.env['API_SERVER'] ?? '';
    final response =
        await http.get(Uri.parse('$apiServer/api/category/categoryList'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  void _showCategoryDialog() async {
    final categories = await _fetchCategories();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
          categories: categories,
          onCategorySelected: (categoryId) {
            setState(() {
              _selectedCategoryId = categoryId;
              _selectedSubCategoryId = null;
            });
            _fetchFilteredList(categoryId, null);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showSubCategoryDialog() async {
    if (_selectedCategoryId == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('알림'),
            content: const Text('대분류를 먼저 골라주세요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
      return;
    }

    final categories = await _fetchCategories();
    final subCategories = categories.firstWhere((category) =>
        category['categoryId'] == _selectedCategoryId)['subCategories'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SubCategoryDialog(
          subCategories: subCategories,
          onSubCategorySelected: (subCategoryId) {
            setState(() {
              _selectedSubCategoryId = subCategoryId;
            });
            _fetchFilteredList(null, subCategoryId);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String appBarTitle = categoryNames[_categoryKind] ?? '카테고리';

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Text(appBarTitle),
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
            Expanded(
                child: _isLoading
                    ? _buildLoading()
                    : mentoringItems.isEmpty
                        ? _buildNoMentoringMessage()
                        : _buildMentoringList()),
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
        ElevatedButton(
          onPressed: () {
            setState(() {
              _selectedCategoryId = null;
              _selectedSubCategoryId = null;
              _fetchMentoringList();
            });
          },
          child: const Text('전체보기'),
        ),
        ElevatedButton(
          onPressed: _showCategoryDialog,
          child: Text(_selectedCategoryId == null ? '대분류' : '선택됨'),
        ),
        ElevatedButton(
          onPressed: _showSubCategoryDialog,
          child: Text(_selectedSubCategoryId == null ? '소분류' : '선택됨'),
        ),
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

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
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
            Navigator.pushNamed(
              context,
              '/mentoringdetail',
              arguments: {
                'classId': item['classId'],
                'mentorId': item['mentorId']
              },
            );
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        item['date']!,
                        style: const TextStyle(color: Colors.grey),
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

  Widget _buildNoMentoringMessage() {
    return const Center(
      child: Text(
        '아직 개설된 멘토링이 없어요.',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
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

class CategoryDialog extends StatelessWidget {
  final List<dynamic> categories;
  final Function(int) onCategorySelected;

  const CategoryDialog(
      {Key? key, required this.categories, required this.onCategorySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('대분류 선택'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map((category) {
            return ListTile(
              title: Text(category['categoryName']),
              onTap: () => onCategorySelected(category['categoryId']),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}

class SubCategoryDialog extends StatelessWidget {
  final List<dynamic> subCategories;
  final Function(int) onSubCategorySelected;

  const SubCategoryDialog(
      {Key? key,
      required this.subCategories,
      required this.onSubCategorySelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('소분류 선택'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: subCategories.map((subCategory) {
            return ListTile(
              title: Text(subCategory['subCategoryName']),
              onTap: () => onSubCategorySelected(subCategory['subCategoryId']),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
