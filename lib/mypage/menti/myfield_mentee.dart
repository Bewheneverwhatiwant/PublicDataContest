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
                onPressed: widget.showCategoryDialog,
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
