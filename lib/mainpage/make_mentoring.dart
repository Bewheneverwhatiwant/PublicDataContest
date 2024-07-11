import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MakeMentoring extends StatefulWidget {
  const MakeMentoring({super.key});

  @override
  _MakeMentoringState createState() => _MakeMentoringState();
}

class _MakeMentoringState extends State<MakeMentoring> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isHourValid = true;
  bool _isMinuteValid = true;
  bool _isPriceValid = true;
  bool _isNameValid = true;
  bool _isLocationValid = true;
  bool _isDescriptionValid = true;

  bool _isHourTouched = false;
  bool _isMinuteTouched = false;
  bool _isPriceTouched = false;
  bool _isNameTouched = false;
  bool _isLocationTouched = false;
  bool _isDescriptionTouched = false;

  bool get _isFormValid {
    return _isHourValid &&
        _isMinuteValid &&
        _isPriceValid &&
        _isNameValid &&
        _isLocationValid &&
        _isDescriptionValid &&
        _hourController.text.isNotEmpty &&
        _minuteController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty;
  }

  String _selectedCategory = '분야를 골라주세요.';
  int _subcategoryId = 1;

  void _validateHour(String value) {
    setState(() {
      _isHourValid = value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) >= 0 &&
          int.parse(value) <= 12;
    });
  }

  void _validateMinute(String value) {
    setState(() {
      _isMinuteValid = value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) >= 0 &&
          int.parse(value) < 60;
    });
  }

  void _validatePrice(String value) {
    setState(() {
      _isPriceValid = value.isNotEmpty &&
          int.tryParse(value) != null &&
          int.parse(value) >= 0 &&
          int.parse(value) <= 1000000;
    });
  }

  void _validateName(String value) {
    setState(() {
      _isNameValid =
          value.isNotEmpty && RegExp(r'^[a-zA-Z가-힣\s]+$').hasMatch(value);
    });
  }

  void _validateLocation(String value) {
    setState(() {
      _isLocationValid =
          value.isNotEmpty && RegExp(r'^[a-zA-Z가-힣\s]+$').hasMatch(value);
    });
  }

  void _validateDescription(String value) {
    setState(() {
      _isDescriptionValid = value.isNotEmpty;
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('${dotenv.env['API_SERVER']}/api/mentoring/make_mentoring'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode({
          'name': _nameController.text,
          'location': _locationController.text,
          'time': int.parse(_hourController.text) * 60 +
              int.parse(_minuteController.text),
          'price': int.parse(_priceController.text),
          'description': _descriptionController.text,
          'subcategoryId': _subcategoryId,
        }),
      );

      print('name: ${_nameController.text}');
      print('location: ${_locationController.text}');
      print(
          'time: ${int.parse(_hourController.text) * 60 + int.parse(_minuteController.text)}');
      print('price: ${int.parse(_priceController.text)}');
      print('description: ${_descriptionController.text}');
      print('subcategoryId: $_subcategoryId');

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('멘토링 개설하기'),
            content: const Text('성공적으로 개설되었습니다!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                child: const Text('확인'),
              ),
            ],
          ),
        );
      } else {
        print('Failed to create mentoring: ${response.body}');
      }
    }
  }

  InputDecoration _inputDecoration(String label, String hintText, bool isValid,
      bool isTouched, String errorText) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      errorText: !isValid && isTouched ? errorText : null,
      border: const OutlineInputBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멘토링 개설하기'),
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '분야',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Text(
                        _selectedCategory,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      _showCategoryDialog();
                    },
                    child: const Text('변경하기'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링 이름',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('멘토링 이름', '멘토링 이름을 입력하세요.',
                    _isNameValid, _isNameTouched, '문자만 작성 가능합니다'),
                onChanged: (value) {
                  _validateName(value);
                  setState(() {
                    _isNameTouched = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링 희망 지역',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _locationController,
                decoration: _inputDecoration('멘토링 희망 지역', '멘토링 희망 지역을 입력하세요.',
                    _isLocationValid, _isLocationTouched, '문자만 작성 가능합니다'),
                onChanged: (value) {
                  _validateLocation(value);
                  setState(() {
                    _isLocationTouched = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '1회당 멘토링 시간',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hourController,
                      decoration: _inputDecoration('시간', '시간을 입력하세요.',
                          _isHourValid, _isHourTouched, '숫자만 입력 가능합니다'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _validateHour(value);
                        setState(() {
                          _isHourTouched = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _minuteController,
                      decoration: _inputDecoration('분', '분을 입력하세요.',
                          _isMinuteValid, _isMinuteTouched, '숫자만 입력 가능합니다'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _validateMinute(value);
                        setState(() {
                          _isMinuteTouched = true;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '1회당 멘토링 가격',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: _inputDecoration('원', '가격을 입력하세요.',
                          _isPriceValid, _isPriceTouched, '숫자만 입력 가능합니다'),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        _validatePrice(value);
                        setState(() {
                          _isPriceTouched = true;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('가격 책정 가이드라인 보기'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                '멘토링 설명',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: _inputDecoration('멘토링 설명', '멘토링 설명을 입력하세요.',
                    _isDescriptionValid, _isDescriptionTouched, '문자만 작성 가능합니다'),
                maxLines: 5,
                onChanged: (value) {
                  _validateDescription(value);
                  setState(() {
                    _isDescriptionTouched = true;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '* 멘토링 기간, 횟수는 멘티와 차후 협의하여 결정',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                    ),
                    onPressed: _isFormValid ? _submitForm : null,
                    child: const Text('멘토링 개설하기'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showCategoryDialog() async {
    final categories = await _fetchCategories();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CategoryDialog(
            categories: categories,
            onSelect: (String selectedCategory, int subcategoryId) {
              setState(() {
                _selectedCategory = selectedCategory;
                _subcategoryId = subcategoryId;
              });
            });
      },
    );
  }

  Future<List<dynamic>> _fetchCategories() async {
    final String apiServer = dotenv.env['API_SERVER'] ?? '';
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';

    final response = await http.get(
      Uri.parse('$apiServer/api/category/subCategory/mentor'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Widget _categoryOption(String category, int id) {
    return ListTile(
      title: Text(category),
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _subcategoryId = id;
        });
        Navigator.of(context).pop();
      },
    );
  }
}

class CategoryDialog extends StatelessWidget {
  final List<dynamic> categories;
  final Function(String, int) onSelect;

  const CategoryDialog({
    Key? key,
    required this.categories,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('분야 선택'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: categories.map<Widget>((category) {
            return ListTile(
              title: Text(
                  '${category['categoryName']} / ${category['subCategoryName']}'),
              onTap: () {
                onSelect(
                    '${category['categoryName']} / ${category['subCategoryName']}',
                    category['subCategoryId']);
                Navigator.of(context).pop();
              },
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
