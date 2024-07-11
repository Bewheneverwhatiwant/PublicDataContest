import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyFieldMentee extends StatefulWidget {
  final List<String> selectedCategories;
  final VoidCallback showCategoryDialog;

  const MyFieldMentee({
    Key? key,
    required this.selectedCategories,
    required this.showCategoryDialog,
  }) : super(key: key);

  @override
  _MyFieldMenteeState createState() => _MyFieldMenteeState();
}

class _MyFieldMenteeState extends State<MyFieldMentee> {
  List<Map<String, String>> menteeCategoryNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenteeCategoryNames();
  }

  Future<void> _fetchMenteeCategoryNames() async {
    final String apiServer = dotenv.env['API_SERVER'] ?? '';
    final String? accessToken = await _getAccessToken();

    if (accessToken == null) {
      print('AccessToken not found');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$apiServer/api/auth/getInfo'),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          if (responseData['mentee'] != null &&
              responseData['mentee']['menteeCategoryNames'] != null &&
              responseData['mentee']['menteeCategoryNames'].isNotEmpty) {
            menteeCategoryNames = List<Map<String, String>>.from(
                responseData['mentee']['menteeCategoryNames']
                    .map((category) => {
                          'categoryName': category['categoryName'].toString(),
                          'subCategoryName':
                              category['subCategoryName'].toString(),
                        }));
          } else {
            menteeCategoryNames = [];
          }
          _isLoading = false;
        });
      } else {
        print('Failed to fetch mentee category names');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching mentee category names: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  void _showCategoryDialog() async {
    final categories = await _fetchCategories();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
          categories: categories,
          onSuccess: () {
            _fetchMenteeCategoryNames();
          },
        );
      },
    );
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

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('내 구직 분야',
                        style: TextStyle(
                            color: GlobalColors.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    menteeCategoryNames.isEmpty
                        ? const Text(
                            '구직 분야를 추가해주세요.',
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: menteeCategoryNames.map((category) {
                              return Text(
                                  '대분류: ${category['categoryName']} / 소분류: ${category['subCategoryName']}');
                            }).toList(),
                          ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _showCategoryDialog,
                style: TextButton.styleFrom(
                  backgroundColor: GlobalColors.mainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '추가하기',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 0.5,
                  ),
                ),
              ),
            ],
          );
  }
}

class CategoryDialog extends StatefulWidget {
  final List<dynamic> categories;
  final VoidCallback onSuccess;

  const CategoryDialog({
    Key? key,
    required this.categories,
    required this.onSuccess,
  }) : super(key: key);

  @override
  _CategoryDialogState createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  List<dynamic>? subCategories;
  String? selectedCategoryName;

  void _showSubCategories(List<dynamic> subCategories, String categoryName) {
    setState(() {
      this.subCategories = subCategories;
      this.selectedCategoryName = categoryName;
    });
  }

  Future<void> _addSubCategory(int subCategoryId) async {
    final String apiServer = dotenv.env['API_SERVER'] ?? '';
    final String? accessToken = await _getAccessToken();

    if (accessToken == null) {
      print('AccessToken not found');
      return;
    }

    final response = await http.post(
      Uri.parse('$apiServer/api/category/subCategory/mentee'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'subCategoryId': [subCategoryId],
      }),
    );

    if (response.statusCode == 200) {
      _showSuccessDialog();
    } else {
      print('Failed to add subcategory');
    }
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('내 구직분야가 등록되었습니다!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                widget.onSuccess();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(selectedCategoryName ?? '카테고리 선택'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (subCategories == null)
              ...widget.categories.map((category) {
                return ListTile(
                  title: Text(category['categoryName']),
                  onTap: () => _showSubCategories(
                      category['subCategories'], category['categoryName']),
                );
              }).toList()
            else
              ...subCategories!.map((subCategory) {
                return ListTile(
                  title: Text(subCategory['subCategoryName']),
                  trailing: ElevatedButton(
                    onPressed: () =>
                        _addSubCategory(subCategory['subCategoryId']),
                    child: const Text('추가하기'),
                  ),
                );
              }).toList()
          ],
        ),
      ),
      actions: [
        if (subCategories != null)
          TextButton(
            onPressed: () {
              setState(() {
                subCategories = null;
                selectedCategoryName = null;
              });
            },
            child: const Text('뒤로가기'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('닫기'),
        ),
      ],
    );
  }
}
