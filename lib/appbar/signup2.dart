import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:publicdatacontest/common/theme/colors/color_palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupStep2 extends StatefulWidget {
  final String name;
  final String dob;
  final String email;
  final String phone;
  final String address;
  final String role;
  final String gender;

  const SignupStep2({
    super.key,
    required this.name,
    required this.dob,
    required this.email,
    required this.phone,
    required this.address,
    required this.role,
    required this.gender,
  });

  @override
  _SignupStep2State createState() => _SignupStep2State();
}

class _SignupStep2State extends State<SignupStep2> {
  bool _isUsernameChecked = false;
  bool _isUsernameValid = false;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _isPasswordMatched = false;
  bool _isUsernameStarted = false;
  bool _isPasswordStarted = false;
  bool _isConfirmPasswordStarted = false;
  bool _isTermsChecked = false;
  bool _isPrivacyChecked = false;
  bool _isAdConsentChecked = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus) {
        setState(() {
          _isUsernameStarted = true;
        });
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        setState(() {
          _isPasswordStarted = true;
        });
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (_confirmPasswordFocusNode.hasFocus) {
        setState(() {
          _isConfirmPasswordStarted = true;
        });
      }
    });
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorStyle: const TextStyle(color: Colors.red),
    );
  }

  bool _validateUsername(String username) {
    return username.isNotEmpty;
  }

  bool _validatePassword(String password) {
    final passwordRegex = RegExp(r'^(?=.*[!@#\$&*~])(?=.*[0-9]).{8,14}$');
    return passwordRegex.hasMatch(password);
  }

  bool _isStep2Valid() {
    return _isUsernameValid &&
        _isUsernameChecked &&
        _isPasswordValid &&
        _isConfirmPasswordValid &&
        _isPasswordMatched;
  }

  void _validateAllFields() {
    setState(() {
      _isUsernameValid = _validateUsername(_usernameController.text);
      _isPasswordValid = _validatePassword(_passwordController.text);
      _isConfirmPasswordValid =
          _passwordController.text == _confirmPasswordController.text;
      _isPasswordMatched =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  Future<void> _signup() async {
    final url =
        '${dotenv.env['API_SERVER']}/api/auth/signup/${widget.role == '멘토' ? 'mentor' : 'mentee'}';

    final requestBody = {
      "userId": _usernameController.text,
      "password": _passwordController.text,
      "name": widget.name,
      "gender": widget.gender,
      "birth": widget.dob,
      "email": widget.email,
      "phoneNumber": widget.phone,
      "address": widget.address,
      "employmentIdea": true,
      "isEmailAlarmAgreed": _isAdConsentChecked,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      },
      body: jsonEncode(requestBody),
    );

    print('Request Body: $requestBody');

    if (response.statusCode == 200) {
      print('Signup Success: $requestBody');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '회원가입되었습니다!',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    } else {
      print('Signup Failed: $requestBody');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              '회원가입 실패',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            content: Text('에러: ${response.reasonPhrase}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    }
  }

// 아이디 중복검사 api 연동
  Future<bool> _checkUserIdDuplicate(String userId) async {
    final accessToken = await _getAccessToken();
    final apiUrl = dotenv.env['API_SERVER'];

    final response = await http.get(
      Uri.parse('$apiUrl/api/auth/id_duplicate?userId=$userId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> _getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken') ?? '';
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.whiteColor,
      appBar: AppBar(
        backgroundColor: GlobalColors.whiteColor,
        title: const Text('회원가입'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Align(
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '항해에 오신 것을 환영합니다!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: GlobalColors.lightgray,
                        child: Text('1', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: GlobalColors.mainColor,
                        child: Text('2', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '아이디',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
                    focusNode: _usernameFocusNode,
                    decoration: _inputDecoration('사용하실 아이디를 입력해주세요.').copyWith(
                      suffixIcon: TextButton(
                        onPressed: () async {
                          if (_validateUsername(_usernameController.text)) {
                            final isSuccess = await _checkUserIdDuplicate(
                                _usernameController.text);
                            if (isSuccess) {
                              setState(() {
                                _isUsernameChecked = true;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('사용 가능한 아이디입니다!'),
                                  backgroundColor: GlobalColors.darkgray,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            } else {
                              setState(() {
                                _isUsernameChecked = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('이미 사용 중인 아이디입니다.'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            }
                          } else {
                            setState(() {
                              _isUsernameChecked = false;
                            });
                          }
                          _validateAllFields();
                        },
                        child: Text(
                          '중복검사',
                          style: TextStyle(
                            color: _isUsernameChecked
                                ? GlobalColors.mainColor
                                : GlobalColors.darkgray,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    style: TextStyle(fontSize: 13),
                    onChanged: (value) {
                      setState(() {
                        _isUsernameValid = _validateUsername(value);
                        _isUsernameChecked = false;
                        _validateAllFields();
                      });
                    },
                  ),
                  if (_isUsernameStarted && !_isUsernameValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '유효한 아이디를 입력해주세요.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    '비밀번호',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: true,
                    decoration: _inputDecoration('비밀번호를 입력해주세요.'),
                    style: TextStyle(fontSize: 13),
                    onChanged: (value) {
                      setState(() {
                        _isPasswordValid = _validatePassword(value);
                        _isPasswordMatched =
                            value == _confirmPasswordController.text;
                        _validateAllFields();
                      });
                    },
                  ),
                  if (_isPasswordStarted && !_isPasswordValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '비밀번호는 특수문자 1개 이상, 숫자 1개 이상, 8글자 이상, 14글자 이하여야 합니다.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    '비밀번호 확인',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    obscureText: true,
                    decoration: _inputDecoration('비밀번호를 다시 입력해주세요.'),
                    style: TextStyle(fontSize: 13),
                    onChanged: (value) {
                      setState(() {
                        _isConfirmPasswordValid =
                            value == _passwordController.text;
                        _isPasswordMatched = value == _passwordController.text;
                        _validateAllFields();
                      });
                    },
                  ),
                  if (_isConfirmPasswordStarted && !_isConfirmPasswordValid)
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: Text(
                        '비밀번호가 일치하지 않습니다.',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 60,
              child: ElevatedButton(
                onPressed: _isStep2Valid()
                    ? () {
                        _showBottomSheet();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isStep2Valid()
                      ? GlobalColors.mainColor
                      : GlobalColors.lightgray,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isStep2Valid()
                        ? GlobalColors.whiteColor
                        : GlobalColors.lightgray,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: GlobalColors.whiteColor, // 투명 배경 설정
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: GlobalColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '약관 전체동의',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    CheckboxListTile(
                      title: const Text('이용약관 동의 (필수)',
                          style: TextStyle(fontSize: 13)),
                      value: _isTermsChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isTermsChecked = value ?? false;
                        });
                      },
                      activeColor: GlobalColors.mainColor,
                    ),
                    CheckboxListTile(
                      title: const Text('개인정보 수집 및 이용동의 (필수)',
                          style: TextStyle(fontSize: 13)),
                      value: _isPrivacyChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPrivacyChecked = value ?? false;
                        });
                      },
                      activeColor: GlobalColors.mainColor,
                    ),
                    CheckboxListTile(
                      title: const Text('E-mail 및 SMS 광고성 정보 수신 동의',
                          style: TextStyle(fontSize: 13)),
                      value: _isAdConsentChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAdConsentChecked = value ?? false;
                        });
                      },
                      activeColor: GlobalColors.mainColor,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isTermsChecked && _isPrivacyChecked
                            ? () {
                                Navigator.pop(context);
                                _signup();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isTermsChecked && _isPrivacyChecked
                              ? GlobalColors.mainColor
                              : GlobalColors.lightgray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: _isTermsChecked && _isPrivacyChecked
                                ? GlobalColors.whiteColor
                                : GlobalColors.lightgray,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
