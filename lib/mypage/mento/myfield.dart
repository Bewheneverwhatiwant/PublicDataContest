import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MyField extends StatefulWidget {
  final List<String> selectedCategories;
  final VoidCallback showCategoryDialog;

  const MyField({
    Key? key,
    required this.selectedCategories,
    required this.showCategoryDialog,
  }) : super(key: key);

  @override
  _MyFieldState createState() => _MyFieldState();
}

class _MyFieldState extends State<MyField> {
  List<Map<String, String>> mentorCategoryNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMentorCategoryNames();
  }

  Future<void> _fetchMentorCategoryNames() async {
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
          if (responseData['mentor'] != null &&
              responseData['mentor']['mentorCategoryNames'] != null &&
              responseData['mentor']['mentorCategoryNames'].isNotEmpty) {
            mentorCategoryNames = List<Map<String, String>>.from(
                responseData['mentor']['mentorCategoryNames']
                    .map((category) => {
                          'categoryName': category['categoryName'].toString(),
                          'subCategoryName':
                              category['subCategoryName'].toString(),
                        }));
          } else {
            mentorCategoryNames = [];
          }
          _isLoading = false;
        });
      } else {
        print('Failed to fetch mentor category names');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching mentor category names: $e');
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
                    Text('내 멘토링 분야',
                        style: TextStyle(
                            color: GlobalColors.mainColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    mentorCategoryNames.isEmpty
                        ? const Text(
                            '멘토링 분야를 추가해주세요.',
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: mentorCategoryNames.map((category) {
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
